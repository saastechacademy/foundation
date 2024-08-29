## Introduction to System Messages in Moqui

System messages are essential for communication between Moqui and external systems. They allow you to send and receive data in various formats, enabling integration with different applications and platforms.

### Key Concepts

* **SystemMessage:** The core entity representing a message. It stores the message content, status, and related metadata.
* **SystemMessageType:** Defines the type of message (e.g., order confirmation, shipment notification).
* **SystemMessageRemote:** Represents a remote system that Moqui interacts with to send or receive messages.
* **Service Job:** A mechanism for scheduling or running asynchronous tasks, often used for processing system messages.
* **SystemMessageError:** Logs errors that occur during message processing.

## Assignment

### Tasks

1. **Create System Message Types:**
    * Define new `SystemMessageType` entities for various types of messages your application will handle "OrderCreated" event.
    * Consider using descriptive names and unique IDs.

2. **Create System Message Remotes:**
    * Define `SystemMessageRemote` entities representing the external systems your application communicates with.
    * Store connection details (e.g., URLs, API keys) for these remote systems.

3. **Implement Service Jobs:**
    * Create `ServiceJob` entities to automate the processing of system messages.
    * Define the service logic for each job (e.g., sending outbound messages, processing incoming messages).
    * Consider using existing Moqui services like `send#ProducedSystemMessage` and `receive#IncomingSystemMessage` to handle message transmission.

4. **Implement Error Handling:**
    * Ensure your service jobs have robust error handling mechanisms.
    * Log errors using the `SystemMessageError` entity to facilitate troubleshooting.

5. **Test Message Processing:**
    * Create sample `SystemMessage` records and test the service jobs to verify that messages are being sent, received, and processed correctly.

### Assignment Submission

Push your new entities, service jobs, and any additional configuration changes to your "moqui-training" repository on GitHub.

### References 
1. https://www.youtube.com/watch?v=HO5qFmqfsA4

