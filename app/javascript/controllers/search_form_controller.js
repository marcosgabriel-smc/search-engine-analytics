import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search-form"
export default class extends Controller {
  handleUserInput() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.search();
      this.log();
    }, 300);
  }

  search() {
    this.element.requestSubmit();
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

  async log() {
    const inputValue = this.element.querySelector("input").value;
    const ipAddress = await this.fetchIpAddress();
    const logData = {
      input: inputValue,
      ip: ipAddress,
    };
    await this.registerLog(logData);
  }

  async registerLog(logData) {
    const csrfToken = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
    try {
      const response = await fetch("/logs", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify(logData),
      });
      const data = await response.json();
      console.log(data);
    } catch (error) {
      console.error("Error registering log:", error);
    }
  }
}
