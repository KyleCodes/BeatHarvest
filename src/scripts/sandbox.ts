import {Playlist, SpotifyApi, TrackItem} from "@spotify/web-api-ts-sdk"
import dotenv from "dotenv"
import {spawn} from "child_process"
import path from "path"
import fs from "fs/promises"
import os from "os"

dotenv.config()

const scopes = [
  "user-read-private",
  "user-read-email",
  "playlist-read-private",
  "playlist-read-collaborative",
  "user-library-read",
  "user-read-playback-state",
  "user-read-recently-played",
  "user-top-read",
]

console.log("client id", process.env.SPOTIFY_API_CLIENT_ID)
console.log("client secret", process.env.SPOTIFY_API_CLIENT_SECRET)

const api = SpotifyApi.withClientCredentials(
  process.env.SPOTIFY_API_CLIENT_ID,
  process.env.SPOTIFY_API_CLIENT_SECRET,
  scopes
)

async function main(): Promise<void> {
  const userPlaylists = await api.playlists.getUsersPlaylists(process.env.SPOTIFY_USER_ID)
  const downloadablePlaylists = userPlaylists.items.filter((playlist) => {
    return playlist.name.toUpperCase().includes("xdj".toUpperCase())
  })

  await downloadPlaylists(downloadablePlaylists)
}

async function downloadPlaylists(playlists: Playlist<TrackItem>[]): Promise<void> {
  const baseDir = path.join(os.homedir(), "Music", "spotdl")
  await fs.mkdir(baseDir, {recursive: true})

  for (const playlist of playlists) {
    try {
      const playlistDir = path.join(baseDir, sanitizeDirectoryName(playlist.name))
      await fs.mkdir(playlistDir, {recursive: true})

      console.log(`Downloading playlist "${playlist.name}" to ${playlistDir}`)

      const spotdl = spawn("spotdl", [playlist.external_urls.spotify], {
        cwd: playlistDir,
        stdio: ["inherit", "pipe", "pipe"],
      })

      spotdl.stdout.pipe(process.stdout)
      spotdl.stderr.pipe(process.stderr)

      spotdl.stdout.on("data", (data) => {
        process.stdout.write(`[${playlist.name}] ${data}`)
      })

      spotdl.stderr.on("data", (data) => {
        process.stderr.write(`[${playlist.name}] Error: ${data}`)
      })

      await new Promise<void>((resolve, reject) => {
        spotdl.on("close", (code) => {
          if (code === 0) {
            console.log(`\nSuccessfully downloaded playlist: ${playlist.name}`)
            resolve()
          } else {
            reject(new Error(`spotdl process exited with code ${code}`))
          }
        })
      })
    } catch (error) {
      console.error(`Error processing playlist "${playlist.name}":`, error)
    }
  }
}

function sanitizeDirectoryName(name: string): string {
  return name
    .replace(/[<>:"/\\|?*]/g, "") // Remove invalid characters
    .replace(/\s+/g, "_") // Replace spaces with underscores
    .trim()
}

main().catch(console.error)
