const express = require('express');
const cors = require('cors');
const crypto = require('crypto'); 
const pool = require('./db');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
    console.log(`[INFO] Menerima permintaan: ${req.method} ${req.url}`);
    next();
});

app.post('/api/auth/register', async (req, res) => {
    const { username, email, password } = req.body;
    try {
        const [result] = await pool.query(
            'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
            [username, email, password]
        );
        
        const userId = result.insertId;
        const token = crypto.randomBytes(16).toString('hex');
        
        await pool.query('UPDATE users SET token = ? WHERE id = ?', [token, userId]);

        res.status(200).json({
            status: 200,               
            success: true,             
            message: "Registrasi berhasil",
            token: token,
            bearer_token: token,
            user: { id: userId, username: username, email: email },
            data: { token: token, bearer_token: token, user: { id: userId, username: username, email: email } }
        });
    } catch (error) {
        console.error("Kesalahan Registrasi:", error);
        res.status(500).json({ status: 500, success: false, error: "Gagal melakukan registrasi." });
    }
});


app.post('/api/auth/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        const [users] = await pool.query(
            'SELECT * FROM users WHERE email = ? AND password = ?',
            [email, password]
        );

        if (users.length > 0) {
            const token = crypto.randomBytes(16).toString('hex');
            await pool.query('UPDATE users SET token = ? WHERE id = ?', [token, users[0].id]);

            res.status(200).json({
                status: 200,               
                success: true,             
                message: "Login berhasil",
                token: token,
                bearer_token: token,
                user: { 
                    id: users[0].id, 
                    username: users[0].username, 
                    email: users[0].email 
                },
                data: {
                    token: token,
                    bearer_token: token,
                    user: { id: users[0].id, username: users[0].username, email: users[0].email }
                }
            });
        } else {
            console.log("[INFO] Login ditolak: Email atau kata sandi tidak valid.");
            res.status(401).json({ status: 401, success: false, message: "Email atau kata sandi tidak valid." });
        }
    } catch (error) {
        console.error("Kesalahan Login:", error);
        res.status(500).json({ status: 500, success: false, message: "Terjadi kesalahan server." });
    }
});

app.get('/api/weapons', async (req, res) => {
    try {
        const [weapons] = await pool.query('SELECT * FROM weapons');
        
        const fixedWeapons = weapons.map(w => ({
            ...w,
            price: parseFloat(w.price),
            crit_rate: parseFloat(w.crit_rate)
        }));

        res.status(200).json(fixedWeapons); 
    } catch (error) {
        console.error("Kesalahan mengambil senjata:", error);
        res.status(500).json({ message: "Gagal mengambil data." });
    }
});

app.get('/api/artifacts', async (req, res) => {
    try {
        const [artifacts] = await pool.query('SELECT * FROM artifacts');

        const fixedArtifacts = artifacts.map(a => {
            const typeMap = {
                'Flower': 'flowerOfLife',
                'Plume': 'plume',
                'Sands': 'sandsOfEon',
                'Goblet': 'gobletOfEonothem',
                'Circlet': 'circletOfLogos',
            };

            return {
                ...a,
                type: typeMap[a.type] || 'flowerOfLife',
                price: parseFloat(a.price),  // <-- ini fix utamanya, sama seperti weapons
            };
        });

        res.status(200).json(fixedArtifacts);
    } catch (error) {
        console.error("Gagal ambil artefak:", error);
        res.status(500).json({ message: "Gagal mengambil artefak." });
    }
});

app.get('/api', (req, res) => {
    res.json({ message: "API Backend Genshin Import telah beroperasi." });
});

const PORT = process.env.PORT || 3000;

app.post('/api/cart', async (req, res) => {

    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.status(401).json({ message: "Token tidak ditemukan" });

    try {

        const [users] = await pool.query('SELECT id FROM users WHERE token = ?', [token]);
        if (users.length === 0) return res.status(403).json({ message: "Token tidak valid" });
        
        const userId = users[0].id;
        const { weapon_id, quantity } = req.body;

        await pool.query(
            'INSERT INTO cart (user_id, weapon_id, quantity) VALUES (?, ?, ?)',
            [userId, weapon_id, quantity]
        );

        res.status(200).json({ message: "Berhasil tambah ke keranjang" });
    } catch (error) {
        res.status(500).json({ message: "Gagal tambah ke keranjang" });
    }
});


app.get('/api/cart', async (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.status(401).json({ message: "Token tidak ditemukan" });

    try {
        const [users] = await pool.query('SELECT id FROM users WHERE token = ?', [token]);
        if (users.length === 0) return res.status(403).json({ message: "Token tidak valid" });
        
        const userId = users[0].id;

        const [cartItems] = await pool.query(`
            SELECT c.id, c.quantity, w.id AS weapon_id, w.name, w.price, w.image_url 
            FROM cart c 
            JOIN weapons w ON c.weapon_id = w.id 
            WHERE c.user_id = ?`, [userId]);

        const formattedCart = cartItems.map(item => ({
            id: item.id.toString(),
            quantity: item.quantity,
            weapon: {
                id: item.weapon_id,
                name: item.name,
                price: parseFloat(item.price),
                imageUrl: item.image_url
            }
        }));

        res.status(200).json(formattedCart);
    } catch (error) {
        res.status(500).json({ message: "Gagal memuat keranjang" });
    }
});

app.delete('/api/cart/:id', async (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ message: "Token tidak ditemukan" });

    try {
        const [users] = await pool.query('SELECT id FROM users WHERE token = ?', [token]);
        if (users.length === 0) return res.status(403).json({ message: "Token tidak valid" });
        
        const userId = users[0].id;
        const cartItemId = req.params.id;

        await pool.query(
            'DELETE FROM cart WHERE id = ? AND user_id = ?', 
            [cartItemId, userId]
        );
        res.status(200).json({ message: "Item berhasil dihapus dari keranjang" });
    } catch (error) {
        res.status(500).json({ message: "Gagal menghapus item" });
    }
});

app.get('/api/users/me', async (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ message: "Token tidak ditemukan" });

    try {
        const [users] = await pool.query(
            'SELECT id, username, email, role FROM users WHERE token = ?', 
            [token]
        );
        if (users.length === 0) return res.status(403).json({ message: "Token tidak valid" });

        res.status(200).json({
            id: users[0].id,
            username: users[0].username,
            email: users[0].email,
            role: users[0].role || 'user',
        });
    } catch (error) {
        console.error("Gagal ambil profile:", error);
        res.status(500).json({ message: "Gagal mengambil data profile." });
    }
});

app.get('/api/weapons/:id', async (req, res) => {
    try {
        const [weapons] = await pool.query(
            'SELECT * FROM weapons WHERE id = ?', 
            [req.params.id]
        );
        if (weapons.length === 0) {
            return res.status(404).json({ message: "Weapon tidak ditemukan" });
        }

        const w = weapons[0];
        res.status(200).json({
            ...w,
            price: parseFloat(w.price),
            crit_rate: parseFloat(w.crit_rate),
        });
    } catch (error) {
        console.error("Gagal ambil weapon:", error);
        res.status(500).json({ message: "Gagal mengambil data weapon." });
    }
});

app.post('/api/weapons', async (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ message: "Token tidak ditemukan" });

    try {
        const [users] = await pool.query('SELECT role FROM users WHERE token = ?', [token]);
        if (users.length === 0) return res.status(403).json({ message: "Token tidak valid" });

        const { name, type, element, rarity, price, stock, description, image_url, attack, crit_rate } = req.body;

        const [result] = await pool.query(
            'INSERT INTO weapons (name, type, element, rarity, price, stock, description, image_url, attack, crit_rate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [name, type || 'sword', element || 'none', rarity || 4, price, stock || 0, description || '', image_url || '', attack || 0, crit_rate || 0]
        );

        const [newWeapon] = await pool.query('SELECT * FROM weapons WHERE id = ?', [result.insertId]);
        const w = newWeapon[0];
        res.status(200).json({
            ...w,
            price: parseFloat(w.price),
            crit_rate: parseFloat(w.crit_rate),
        });
    } catch (error) {
        console.error("Gagal tambah weapon:", error);
        res.status(500).json({ message: "Gagal menambahkan weapon." });
    }
});

app.put('/api/weapons/:id', async (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ message: "Token tidak ditemukan" });

    try {
        const [users] = await pool.query('SELECT role FROM users WHERE token = ?', [token]);
        if (users.length === 0) return res.status(403).json({ message: "Token tidak valid" });

        const { name, type, element, rarity, price, stock, description, image_url, attack, crit_rate } = req.body;
        const weaponId = req.params.id;

        await pool.query(
            'UPDATE weapons SET name=?, type=?, element=?, rarity=?, price=?, stock=?, description=?, image_url=?, attack=?, crit_rate=? WHERE id=?',
            [name, type || 'sword', element || 'none', rarity || 4, price, stock || 0, description || '', image_url || '', attack || 0, crit_rate || 0, weaponId]
        );

        const [updated] = await pool.query('SELECT * FROM weapons WHERE id = ?', [weaponId]);
        if (updated.length === 0) return res.status(404).json({ message: "Weapon tidak ditemukan" });

        const w = updated[0];
        res.status(200).json({
            ...w,
            price: parseFloat(w.price),
            crit_rate: parseFloat(w.crit_rate),
        });
    } catch (error) {
        console.error("Gagal update weapon:", error);
        res.status(500).json({ message: "Gagal mengupdate weapon." });
    }
});

app.delete('/api/weapons/:id', async (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ message: "Token tidak ditemukan" });

    try {
        const [users] = await pool.query('SELECT role FROM users WHERE token = ?', [token]);
        if (users.length === 0) return res.status(403).json({ message: "Token tidak valid" });

        const weaponId = req.params.id;
        const [existing] = await pool.query('SELECT id FROM weapons WHERE id = ?', [weaponId]);
        if (existing.length === 0) return res.status(404).json({ message: "Weapon tidak ditemukan" });

        await pool.query('DELETE FROM weapons WHERE id = ?', [weaponId]);
        res.status(200).json({ message: "Weapon berhasil dihapus" });
    } catch (error) {
        console.error("Gagal hapus weapon:", error);
        res.status(500).json({ message: "Gagal menghapus weapon." });
    }
});

app.post('/api/orders', async (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ message: "Token tidak ditemukan" });

    try {
        const [users] = await pool.query('SELECT id FROM users WHERE token = ?', [token]);
        if (users.length === 0) return res.status(403).json({ message: "Token tidak valid" });

        const userId = users[0].id;
        const { items } = req.body;

        for (const item of items) {
            const [weapons] = await pool.query('SELECT stock FROM weapons WHERE id = ?', [item.weapon_id]);
            if (weapons.length === 0) return res.status(404).json({ message: `Weapon tidak ditemukan` });
            if (weapons[0].stock < item.quantity) return res.status(400).json({ message: `Stock tidak cukup` });

            await pool.query('UPDATE weapons SET stock = stock - ? WHERE id = ?', [item.quantity, item.weapon_id]);
        }

        await pool.query('DELETE FROM cart WHERE user_id = ?', [userId]);

        res.status(200).json({ message: "Order berhasil" });
    } catch (error) {
        console.error("Gagal buat order:", error);
        res.status(500).json({ message: "Gagal memproses order." });
    }
});

app.listen(PORT, () => {
    console.log(`Server beroperasi pada port ${PORT}`);
});