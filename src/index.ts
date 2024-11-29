import express, {Request, Response} from "express"
import {Pool} from "pg"
import dotenv from "dotenv"

dotenv.config()

const pool = new Pool({
  user: process.env.DB_USER,
  host: "localhost",
  database: "helloworld",
  password: process.env.DB_PASSWORD,
  port: 5432,
})

const app = express()
const port = process.env.WWW_PORT

app.get("/", (req: Request, res: Response) => {
  res.send("hello world")
})

app.get("/users", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM users")
    res.json(result.rows)
  } catch (err) {
    console.error(err)
    res.status(500).send("Error fetching users")
  }
})

app.post("/users", async (req, res) => {
  const {name, email} = req.body
  try {
    const result = await pool.query("INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *", [name, email])
    res.json(result.rows[0])
  } catch (err) {
    console.error(err)
    res.status(500).send("Error adding user")
  }
})

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`)
})
