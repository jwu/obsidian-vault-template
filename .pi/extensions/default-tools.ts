// Activate the built-in grep, find, and ls tools (defined but not active by default).
// Uses "session_start" event because getActiveTools/setActiveTools require
// the extension runtime to be fully initialized before they can be called.

export default function (pi: {
  getActiveTools(): string[];
  setActiveTools(names: string[]): void;
  on(event: "session_start", handler: () => void): void;
}) {
  pi.on("session_start", () => {
    const active = pi.getActiveTools();
    pi.setActiveTools([...active, "grep", "find", "ls"]);
  });
}
