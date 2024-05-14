# Lifeless: Video Game’s New Era

Welcome to the official GitHub repository for Lifeless, an experimental video game prototype that leverages AI to enhance NPC interactions and improve player experience. This project demonstrates how AI can add depth and immersion to game worlds without significantly increasing development resources.

## Table of Contents
- [Project Description](#project-description)
- [How to Use](#how-to-use)
- [Controllers](#controllers)
- [Technologies Used](#technologies-used)
- [Contact](#contact)

## Project Description

**Lifeless** is an innovative project aimed at testing the integration of AI with NPCs in video games. By using AI, we can dynamically generate dialogues, adapt NPC behaviors to the context, and introduce memory systems for NPCs to remember player interactions. This project is a proof-of-concept sandbox environment where players can interact with AI-driven characters to simulate a more immersive gaming experience.

## How to Use

### Using Release Binaries

1. **Download the Latest Release:**
   - Go to the [Releases](https://github.com/D3C0D/Lifeless/releases) section of the GitHub repository.
   - Download the latest release for your operating system.

2. **Extract and Run:**
   - Extract the downloaded zip file to your preferred location.
   - Run the `Lifeless.exe` (Windows) or the corresponding executable for your OS.

3. **Interact with the Game:**
   - Follow the in-game instructions to create and interact with Lifeless characters.

### Cloning the Repository and Using Godot Editor

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/D3C0D/Lifeless.git
   ```

2. **Open Godot Editor:**
   - Launch the Godot 4 editor.
   - In the project manager, click on `Import` and navigate to the cloned repository directory.
   - Select the `project.godot` file and open it.

3. **Run the Project:**
   - In the Godot editor, click on the `Play` button to run the project.

4. **Modify and Explore:**
   - Now you can add as many features as you want, I will be glad to see this project be expanded upon.

## Controllers

- **Movement:**
  - Use the mouse to click on the map and move your character.
  - Left-click to interact with NPCs and objects.
  - Use the camera controls to zoom in and out with the mouse wheel.

- **Menu Navigation:**
  - Press `Esc` to open the configuration menu.
  - Use `PgDn` to return to the debug menu from any module.

## Technologies Used

- **Ollama:**
  - The Ollama framework serves as the backend for all AI processing and text generation. It uses the Llama 3 model, which can be substituted with other models if necessary. Ollama allows the game to generate dynamic dialogues and responses from NPCs based on player interactions.

- **Godot 4:**
  - Godot 4 is an open-source game engine used for developing Lifeless. It offers flexibility and rapid prototyping capabilities. Godot’s built-in functions for pathfinding and sprite management, along with plugins like [LPCAnimatedSprite2D](https://github.com/alextrevisan/LPCAnimatedSprite2D), enable easy customization and animation of NPCs.

- **Liberated Pixel Cup (LPC) Sprites:**
  - The sprites used for Lifeless characters are sourced from the Liberated Pixel Cup on Open Game Art. These sprites are freely available under the CC BY-SA 3.0 license and provide extensive customization options for creating unique NPC appearances.

- **JSON Files:**
  - JSON files are used to store NPC data, including names, surnames, and descriptions. These files can also be used to store conversational memory, allowing NPCs to remember interactions across sessions.

- **HTTP Requests:**
  - HTTP requests facilitate communication between the game and the AI backend. The game sends parameters to the Ollama server using the API, and in return, receives dynamically generated dialogues for NPC interactions.

## Contact

Project developed by Luis Chacón
- [LinkedIn](https://www.linkedin.com/in/luis-chacon-mora/)
- [Itch.io](https://amenohi.itch.io/)

Feel free to reach out for any inquiries or further discussion about the project. Contributions and forks are welcome, provided proper attribution is maintained.

---

Thank you for exploring Lifeless! We hope this project inspires new ways to integrate AI into game development and create richer, more immersive player experiences.
