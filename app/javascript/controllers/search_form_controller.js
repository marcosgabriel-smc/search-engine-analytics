import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search-form"
export default class extends Controller {
  handleUserInput() {
    this.search();
    this.log();
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.element.requestSubmit();
    }, 200);
  }

  async log() {
    const inputValue = this.element.querySelector("input").value;
    const ipAddress = await this.fetchIpAddress();
    const logData = {
      input: inputValue,
      ipAddress: ipAddress,
    };
  }

  async fetchIpAddress() {
    try {
      const response = await fetch("https://api.ipify.org?format=json");
      const data = await response.json();
      return data.ip;
    } catch (error) {
      console.error("Error fetching IP address:", error);
      return "Unknown IP";
    }
  }
}
