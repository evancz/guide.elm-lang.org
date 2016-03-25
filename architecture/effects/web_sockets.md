# Web Sockets

We are going to make a simple chat app. There will be a text field so you can type things in and a region that shows all the messages we have received so far. Web sockets are great for this scenario because they let us set up a persistent connection with the server. This means:

  1. You can send messages cheaply whenever you want.
  2. The server can send *you* messages whenever it feels like it.

In other words, `WebSocket` is one of the rare libraries that makes use of both commands and subscriptions.





For simplicity we will target a simple server that just echos back whatever you type. So you will not be able to have the most exciting conversations in the basic version, but that is why we have exercises on these examples!

