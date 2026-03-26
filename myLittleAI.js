const { exec, spawn } = require('child_process');
const { init, getAuthToken } = require("@heyputer/puter.js/src/init.cjs");
const util = require('util');
const execPromise = util.promisify(exec);

async function askAI(puter) {
    try {
        // 1. Get input
        const { stdout } = await execPromise('zenity --title="Ask away!" --entry --text="Write a question:"');
        const userInput = stdout.trim();
        if (!userInput) return false;

        // 2. Start Progress Bar (Pulse)
        const progress = spawn('zenity', ['--progress', '--title=THE AI', '--text=Thinking...', '--pulsate', '--auto-close', '--no-cancel']);

        // 3. Get AI Response
        const response = await puter.ai.chat(userInput);
        
        // 4. STOP Progress Bar
        progress.kill();

        // 5. Show Answer
        const text = response.message.content.replace(/"/g, "'");
        await execPromise(`zenity --info --text="${text}" --width=700 --height=500 `);
        
        return true; // Keep looping
    } catch (error) {
        return false; // User hit cancel
    }
}

async function main() {
    const token = await getAuthToken();
    const puter = init(token);
	
    
    let active = true;
    while (active) {
        active = await askAI(puter);
    }
    console.log("Done.");
}

main();
