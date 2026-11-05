const express = require('express');
const app = express();

app.get('/health', (req, res) => res.json({ status: 'ok' }));
app.get('/ready', (req, res) => res.json({ ready: true }));
app.get('/', (req, res) => res.json({ message: 'Startup API' }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Listening on ${PORT}`));

module.exports = app;   