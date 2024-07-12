import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="charts"
export default class extends Controller {
  toggleCharts(event) {
    const buttonId = event.target.id;
    const mapChart = document.querySelector("#map-chart");
    const multilineChart = document.querySelector("#multiline-chart");
    const topUsersChart = document.querySelector("#top-users-chart");
    const latestChart = document.querySelector("#latest-chart");

    switch (buttonId) {
      case "map":
        mapChart.style.display = "block";
        multilineChart.style.display = "none";
        topUsersChart.style.display = "none";
        latestChart.style.display = "none";
        break;
      case "multiline":
        mapChart.style.display = "none";
        multilineChart.style.display = "block";
        topUsersChart.style.display = "none";
        latestChart.style.display = "none";
        break;
      case "top-users":
        mapChart.style.display = "none";
        multilineChart.style.display = "none";
        topUsersChart.style.display = "block";
        latestChart.style.display = "none";
        break;
      case "latest":
        this.filterLogs();
        mapChart.style.display = "none";
        multilineChart.style.display = "none";
        topUsersChart.style.display = "none";
        latestChart.style.display = "block";
        break;
      default:
        console.log("Unknown button ID");
    }
  }

  async filterLogs() {
    const csrfToken = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");
    try {
      const response = await fetch("/logs/filter_logs", {
        method: "POST",
        headers: {
          "X-CSRF-Token": csrfToken,
        },
      });
      const data = await response.json();
      console.log(data);
    } catch (error) {
      console.error("Error registering log:", error);
    }
  }
}
