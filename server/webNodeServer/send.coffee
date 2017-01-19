
email = require ("emailjs")

fs = require ("fs")
config = JSON.parse(fs.readFileSync("#{process.cwd()}/config.json"), "utf-8")

server = email.server.connect
    user: config.username
    password: config.password
    host: config.smtp.host
    ssl: config.smtp.ssl

message = email.message.create 
    text: "This is test"
    from: "#{config.name} <#{config.email}>"
    to: "#{config.name} <#{config.email}>"
    subject: "Testing Node.js email capabilities"

message.attach ("reading.png", "image/png", "reading-image.png")

server.send (message, (err, message)) ->
    return console.error err if err
    console.log "Message sent with id #{message['header']['message-id']}"
