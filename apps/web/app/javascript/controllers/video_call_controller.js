import { Controller } from "@hotwired/stimulus";
import Video from "twilio-video";

export default class extends Controller {
  static values = { roomName: String, accessToken: String };

  connect() {
    this.localContainer = document.getElementById("local-video");
    this.remoteContainer = document.getElementById("remote-video");
    this.room = null;
    this.localTracks = [];
    this.isMuted = false;
    this.isVideoHidden = false;
  }

  async join() {
    const token = this.accessTokenValue;
    const roomName = this.roomNameValue;

    if (!token || !roomName) return console.error("Missing Twilio token or room name.");

    try {
      this.localTracks = await Video.createLocalTracks({ audio: true, video: true });
      this.addLocalVideo();

      this.room = await Video.connect(token, {
        name: roomName,
        tracks: this.localTracks,
      });

      console.log(`Connected to room: ${this.room.name}`);
      this.remoteContainer.innerHTML = "";

      // Attach already-present participants
      this.room.participants.forEach(p => this.attachParticipant(p));

      // Listen for new participants
      this.room.on("participantConnected", p => this.attachParticipant(p));
      this.room.on("participantDisconnected", p => this.removeParticipant(p));

    } catch (err) {
      console.error("Error connecting to Twilio room:", err);
    }
  }

  addLocalVideo() {
    const videoTrack = this.localTracks.find(track => track.kind === "video");
    if (videoTrack) {
      this.localContainer.innerHTML = "";
      this.localContainer.appendChild(videoTrack.attach());
    }
  }

  attachParticipant(participant) {
    console.log(`Participant connected: ${participant.identity}`);

    // Prevent duplicate container
    if (document.getElementById(`participant-${participant.sid}`)) return;

    const container = document.createElement("div");
    container.id = `participant-${participant.sid}`;
    container.classList.add("w-full", "h-full", "flex", "justify-center", "items-center");
    this.remoteContainer.appendChild(container);

    // Attach only subscribed tracks
    participant.tracks.forEach(publication => {
      if (publication.isSubscribed && publication.track) {
        container.appendChild(publication.track.attach());
      }
    });

    // Listen for future subscribed tracks
    participant.on("trackSubscribed", track => container.appendChild(track.attach()));
    participant.on("trackUnsubscribed", track => track.detach().forEach(el => el.remove()));
  }

  removeParticipant(participant) {
    const container = document.getElementById(`participant-${participant.sid}`);
    if (container) container.remove();
    console.log(`Participant disconnected: ${participant.identity}`);
  }

  leave() {
    if (this.room) {
      this.room.disconnect();
      this.room = null;
      this.localContainer.innerHTML = "";
      this.remoteContainer.innerHTML = "Call ended.";
      console.log("Left the room");
    }
  }
}
