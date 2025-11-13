import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];

  connect() {
    this.messageTargets.forEach((el) => {
      setTimeout(() => {
        el.classList.add("-translate-y-full");

        setTimeout(() => {
          el.remove();
        }, 300);
      }, 3000);
    });
  }
}
