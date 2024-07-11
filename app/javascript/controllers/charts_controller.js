import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="charts"
export default class extends Controller {
  toggleCharts(event) {
    const buttonId = event.target.id;
    const mapChart = document.querySelector("#map-chart");
    const multilineChart = document.querySelector("#multiline-chart");
    const topUsersChart = document.querySelector("#top-users-chart");

    console.log(buttonId, mapChart, multilineChart, topUsersChart);

    switch (buttonId) {
      case "map":
        mapChart.style.display = "block";
        multilineChart.style.display = "none";
        topUsersChart.style.display = "none";
        break;
      case "multiline":
        mapChart.style.display = "none";
        multilineChart.style.display = "block";
        topUsersChart.style.display = "none";
        break;
      case "top-users":
        mapChart.style.display = "none";
        multilineChart.style.display = "none";
        topUsersChart.style.display = "block";
        break;
      default:
        console.log("Unknown button ID");
    }
  }
}
