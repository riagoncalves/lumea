import { Controller } from "@hotwired/stimulus";
import Video from "twilio-video";

export default class extends Controller {
  static values = {
    roomName: String,
    accessToken: String
  };

  connect() {
    this.localContainer = document.getElementById("local-video");
    this.remoteContainer = document.getElementById("remote-video");
    this.room = null;
  }

  async join() {
    const token = this.accessTokenValue;
    const roomName = this.roomNameValue;

    if (!token || !roomName) {
      console.error("Missing Twilio token or room name.");
      return;
    }

    try {
      this.room = await Video.connect(token, {
        name: roomName,
        audio: true,
        video: true, // can still join without a camera
      });

      console.log(`Connected to room: ${this.room.name}`);
      console.log("Local identity:", this.room.localParticipant.identity);

      await this.addLocalMedia();
      this.setupParticipants();
    } catch (err) {
      console.error("Error connecting to Twilio room:", err);
    }
  }

  async addLocalMedia() {
    try {
      const tracks = await Video.createLocalTracks({ audio: true, video: true });
      tracks.forEach(track => {
        this.localContainer.appendChild(track.attach());
      });
    } catch (err) {
      console.warn("Could not create local video track (maybe voice only):", err);
    }
  }

  setupParticipants() {
    // Handle already-connected participants
    this.room.participants.forEach(p => this.participantConnected(p));

    // Handle future joins/disconnects
    this.room.on("participantConnected", p => this.participantConnected(p));
    this.room.on("participantDisconnected", p => this.participantDisconnected(p));
  }

  participantConnected(participant) {
    console.log(`Participant connected: ${participant.identity}`);

    // Create a container for this participant
    const container = document.createElement("div");
    container.id = `participant-${participant.sid}`;
    container.classList.add("participant-container");
    this.remoteContainer.appendChild(container);

    // Attach already published tracks
    participant.tracks.forEach(pub => {
      if (pub.isSubscribed) {
        container.appendChild(pub.track.attach());
      }
    });

    // Listen for future tracks
    participant.on("trackSubscribed", track => {
      container.appendChild(track.attach());
    });

    participant.on("trackUnsubscribed", track => {
      track.detach().forEach(el => el.remove());
    });
  }

  participantDisconnected(participant) {
    console.log(`Participant disconnected: ${participant.identity}`);
    const container = document.getElementById(`participant-${participant.sid}`);
    if (container) container.remove();
  }

  leave() {
    if (this.room) {
      this.room.disconnect();
      this.room = null;
      console.log("Left the room");
      this.localContainer.innerHTML = "";
      this.remoteContainer.innerHTML = "";
    }
  }
}
