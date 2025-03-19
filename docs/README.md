# Docs

We are using [Nextra](https://nextra.site) for our documentation.

## Running the documentation locally

Install the dependencies:

```bash
npm install
```

Run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the
result. When you modify the files, the server will automatically update the
changes.

## Record videos

We use [Screen Studio](https://screen.studio/) on a Mac to record videos. Also,
we set the window size to `1200 x 800`. Use the following Apple script to set the
window size of Sharezone:

```applescript
tell application "System Events"
	set theApp to "Sharezone" -- Replace with the name of your application
	tell application theApp to activate
	tell process theApp
		set frontWindow to the first window
		set size of frontWindow to {1200, 800} -- Replace with your desired width and height
	end tell
end tell
```

How to run the script:
1. Open Sharezone on macOS
2. Open the script with AppleScript Editor
3. Press the "Run" button

We upload the video to Firebase Storage at `gs://sharezone-c2bd8.appspot.com/docs`.