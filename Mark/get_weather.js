require("dotenv").config();
const axios = require("axios");
const fs = require("fs");
const path = require("path");

// 1. Define your 15 target cities
const CITIES = [
  "Sydney",
  "Adelaide",
  "Melbourne",
  "Perth",
  "Hobart",
  "Brisbane",
  "Launceston",
  "Geelong",
  "Alice Springs",
  "Canberra",
  "Gold Coast",
  "Moe",
  "Coffs Harbour",
  "Cairns",
  "Albury",
];

// Helper delay function to avoid hitting API rate limits
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

// Helper function to fetch a single date range chunk
const fetchWeatherChunk = async (location, startDate, endDate) => {
  try {
    const { data } = await axios.get(
      "https://api.worldweatheronline.com/premium/v1/past-weather.ashx",
      {
        params: {
          key: process.env.WWO_API_KEY,
          q: `${location},Australia`,
          date: startDate,
          enddate: endDate,
          format: "json",
        },
      }
    );

    return data.data?.weather || [];
  } catch (error) {
    console.error(`Error fetching \({location} [\){startDate} to ${endDate}]:`, error.message);
    return [];
  }
};

const fetchAllWeather = async () => {
  // Ensure output directory exists
  const outputDir = path.join(__dirname, "weather_data");
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Loop through 2011 to 2025 (Dec 05, 2025 to Feb 17, 2026 covers the 2025-2026 period)
  const startYear = 2011;
  const endYear = 2025;

  for (const city of CITIES) {
    console.log(`\n--- Fetching data for: ${city} ---`);
    let cityWeatherData = [];

    for (let year = startYear; year <= endYear; year++) {
      const nextYear = year + 1;

      // Split the range into two chunks < 30 days
      const chunk1Start = `${year}-12-05`;
      const chunk1End = `${nextYear}-01-10`;

      const chunk2Start = `${nextYear}-01-11`;
      const chunk2End = `${nextYear}-02-17`;

      console.log(`Fetching ${city}: Dec 05, ${year} to Feb 17, ${nextYear}...`);

      // Request Chunk 1
      const data1 = await fetchWeatherChunk(city, chunk1Start, chunk1End);
      await sleep(200); // 200ms delay between requests

      // Request Chunk 2
      const data2 = await fetchWeatherChunk(city, chunk2Start, chunk2End);
      await sleep(200);

      // Combine daily weather objects into the city's dataset
      cityWeatherData.push(...data1, ...data2);
    }

    // Save each city to its own JSON file
    const filePath = path.join(outputDir, `${city.replace(/\s+/g, "_")}.json`);
    fs.writeFileSync(filePath, JSON.stringify(cityWeatherData, null, 2));
    console.log(`Saved: ${filePath}`);
  }

  console.log("\nAll weather data successfully downloaded!");
};

fetchAllWeather();