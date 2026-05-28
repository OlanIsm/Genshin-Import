const mysql = require('mysql2');
require('dotenv').config();

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

pool.getConnection((err, conn) => {
    if (err) console.error('Gagal terhubung ke database:', err.message);
    else {
        console.log('Berhasil terkoneksi ke database Genshin-Import');
        conn.release();
    }
});

module.exports = pool.promise();