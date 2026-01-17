const fs = require('fs');

const content = `window.TOSS_ENV = {
    PINATA_API_KEY: "${process.env.PINATA_API_KEY || ''}",
    PINATA_SECRET_API_KEY: "${process.env.PINATA_SECRET_API_KEY || ''}"
};`;

fs.writeFileSync('env.js', content);
console.log('env.js generated successfully');
