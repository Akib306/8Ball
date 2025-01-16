const express = require('express');
const path = require('path');


const app = express();


app.use(express.static(path.join(__dirname, '../client/Exports/web')));


app.get('/test', (req, res) => {
    res.sendFile(path.join(__dirname, '../client/Exports/web/index.html'));
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});