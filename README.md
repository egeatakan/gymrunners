# GymRunners: Your AI-Powered Running Companion

## Project Overview

GymRunners is an innovative Flutter mobile application designed to enhance your running experience, whether you're outdoors or on a treadmill. It acts as your personal running companion, tracking key metrics and providing a unique virtual racing experience against an AI bot. The core idea is to motivate users through real-time feedback and engaging challenges, helping them push their limits and achieve their fitness goals.

## Key Features

* **Comprehensive Run Tracking:**
    * **Average Speed:** Tracks and displays your average speed in meters per second (m/s).
    * **Run Duration:** Records the total time of your run in seconds.
    * **Accurate Distance Calculation:** Calculates total distance covered in meters, prioritizing accuracy by deriving it from accumulated speed (m/s) over time, rather than solely relying on GPS coordinates.
    * **Total Step Count:** Provides a precise count of your steps taken during the run.

* **Treadmill Compatibility:**
    * Designed to work seamlessly on treadmills. When GPS data is unavailable or inaccurate (as is common indoors), the application intelligently utilizes accelerometer data and step counting for reliable speed and distance calculations.

* **Virtual AI Bot Race:**
    * Engage in real-time races against a virtual AI bot from the moment you start your run. Challenge yourself and stay motivated!

* **Dynamic Difficulty Levels for AI Bot:**
    * **Easy:** A relaxed pace for beginners or recovery runs.
    * **Medium:** A moderate challenge for consistent training.
    * **Hard:** A fast pace to push your limits.
    * **Dynamic:** The bot's speed intelligently adapts based on the average speed of your last X runs, providing a personalized and evolving challenge.

* **Intuitive Sensor-Based Interactions:**
    * **Hands-Free Operation:** The in-run UI is intentionally minimal, allowing runners to focus on their activity.
    * **Time Difference Announcement:** Perform a specific physical gesture (e.g., three rapid forward-and-backward arm swings detected by motion sensors) to audibly hear the time difference (in seconds) between you and the virtual bot.
    * **Proximity Alert:** As you get closer to the AI bot (whether catching up or being overtaken), the app emits a beeping sound. The closer you are, the more frequent and intense the beeps, providing crucial real-time audio feedback.

## Technical Stack

* **Mobile Framework:** Flutter
* **AI Integration:** Powered by advanced AI models (e.g., Gemini 2.5 via API) for bot logic and dynamic difficulty adjustments.
* **Sensor Utilization:** Leverages device motion sensors (accelerometer, gyroscope) for gesture detection and accurate step counting.
* **Audio Feedback:** Implements clear and timely sound alerts for an enhanced user experience.

## Getting Started

To get a local copy up and running, follow these simple steps:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/egeatakan/gymrunners.git](https://github.com/egeatakan/gymrunners.git)
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd gymrunners
    ```
3.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the application:**
    ```bash
    flutter run
    ```

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star!

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Your Name - egeatakan@gmail.com

Project Link: [https://github.com/egeatakan/gymrunners](https://github.com/egeatakan/gymrunners)
