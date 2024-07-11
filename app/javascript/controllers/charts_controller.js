import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="charts"
export default class extends Controller {
  toggleCharts(event) {
    const buttonId = event.target.id;
    const mapChartContent = document.querySelector("#map-chart-content");
    const multilineChartContent = document.querySelector(
      "#multiline-chart-content"
    );
    console.log(buttonId, mapChartContent, multilineChartContent);

    if (buttonId === "map-chart") {
      mapChartContent.style.display = "block";
      multilineChartContent.style.display = "none";
    } else if (buttonId === "multiline-chart") {
      mapChartContent.style.display = "none";
      multilineChartContent.style.display = "block";
    }
  }
}
