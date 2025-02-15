# Use the official Swift image based on Ubuntu
FROM swift:6.0.2-jammy AS build

# Set the working directory in the container
WORKDIR /app

# Copy the entire Swift package into the container
COPY . .

# Build the Swift package
RUN swift build -c release

# Use a smaller image for running the app
FROM swift:6.0.2-jammy-slim AS runtime

# Copy the built executable to /usr/local/bin
# Replace DDBKit-Template with the name of your app executable (specified in Package.swift)
COPY --from=build /app/.build/release/DDBKit-Template /usr/local/bin/DDBKit-Template

# This is the command that will start the bot in your docker container, usually just the name of the executable itself.
ENTRYPOINT ["DDBKit-Template"]
