import { Controller } from "@hotwired/stimulus"
import Video from "twilio-video"

export default class extends Controller {
  static values = { roomName: String }

  connect() {
    this.localContainer = document.getElementById("local-video")
    this.remoteContainer = document.getElementById("remote-video")
    this.room = null
  }

  async join() {
    const roomName = this.roomNameValue
    const response = await fetch(`/api/twilio/token?room=${roomName}`)
    const data = await response.json()
    const token = data.token

    try {
      this.room = await Video.connect(token, {
        name: roomName,
        audio: true,
        video: { width: 640, height: 480 }
      })

      console.log(`Connected to room ${this.room.name}`)
      this.addLocalVideo()
      this.setupParticipants()
    } catch (err) {
      console.error("Error connecting to Twilio:", err)
    }
  }

  async addLocalVideo() {
    const track = await Video.createLocalVideoTrack()
    this.localContainer.innerHTML = ""
    this.localContainer.appendChild(track.attach())
  }

  setupParticipants() {
    this.room.participants.forEach(this.participantConnected.bind(this))
    this.room.on("participantConnected", this.participantConnected.bind(this))
    this.room.on("participantDisconnected", this.participantDisconnected.bind(this))
  }

  participantConnected(participant) {
    console.log(`Participant connected: ${participant.identity}`)
    participant.tracks.forEach(publication => {
      if (publication.isSubscribed) {
        this.remoteContainer.appendChild(publication.track.attach())
      }
    })

    participant.on("trackSubscribed", track => {
      this.remoteContainer.appendChild(track.attach())
    })
  }

  participantDisconnected(participant) {
    console.log(`Participant disconnected: ${participant.identity}`)
    participant.tracks.forEach(publication => {
      if (publication.track) publication.track.detach().forEach(el => el.remove())
    })
  }

  leave() {
    if (this.room) {
      this.room.disconnect()
      this.room = null
      console.log("Left the room")
      this.localContainer.innerHTML = ""
      this.remoteContainer.innerHTML = ""
    }
  }
}
