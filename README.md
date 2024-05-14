# DevContainer Configurations

Welcome to the DevContainer Configurations repository! This repository contains a collection of development container (devcontainer) configurations for various project types. These configurations are intended to simplify the setup of development environments by using Visual Studio Code's Remote - Containers extension.

## Repository Structure

The repository includes the following devcontainer configurations:

- `front-end-proxy/.devcontainer`: Configuration for front-end projects with a proxy setup.
- `front-end/.devcontainer`: Basic configuration for front-end development.
- `laravel 10/.devcontainer`: Setup for Laravel 10 projects.
- `light-with-db/.devcontainer`: Lightweight configuration with a database setup.

## How to Use

To use any of these devcontainer configurations in your project, follow these steps:

1. **Clone the Repository**: Start by cloning this repository to your local machine.

    ```sh
    git clone https://github.com/your-username/devcontainer-configurations.git
    ```

2. **Copy the Desired Configuration**: Navigate to the desired configuration folder and copy the `.devcontainer` directory to the root of your project.

    ```sh
    cp -r devcontainer-configurations/front-end/.devcontainer /path/to/your/project/
    ```

3. **Open in Visual Studio Code**: Open your project in Visual Studio Code. If you have the Remote - Containers extension installed, VS Code will detect the `.devcontainer` directory and prompt you to reopen the project in a container.

4. **Reopen in Container**: Follow the prompts to reopen your project in the container. VS Code will build the container based on the provided configuration and set up your development environment.

## Contributing

If you have any improvements or additional configurations to add, feel free to open a pull request or submit an issue.
