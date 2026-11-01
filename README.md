# Bachat Bhai 🛒 grocery cart comparison for any AI app

Send one grocery list. Bachat Bhai builds the same cart on **Zepto, Swiggy Instamart, Blinkit and Flipkart Minutes**, reads the **real bill** on each (every fee included), tells you the cheapest, and fills that cart for you. It never places an order without your "yes".

Works in Claude Desktop, Claude Code, Cursor, VS Code, ChatGPT (limited) and any app that supports MCP.

**Free.** No server, no hosting, no sign-up with us, no API keys. It uses Zepto's and Swiggy's **official** MCP connectors plus an optional free, open-source browser tool that runs on your own computer. You only need the AI app you already use.

## What's in this pack

| File | What it's for |
|---|---|
| `skills/bachat-bhai/SKILL.md` | The instructions, as an Agent Skill (Claude, Claude Code, Cursor, other skill-aware apps) |
| [`dist/bachat-bhai-skill.zip`](https://github.com/amishah1998/bachat-bhai/raw/main/dist/bachat-bhai-skill.zip) | The same skill zipped, ready to upload in Claude ([one-click download](https://github.com/amishah1998/bachat-bhai/raw/main/dist/bachat-bhai-skill.zip)) |
| `AGENTS.md` | The same instructions without skill frontmatter, for apps that read AGENTS.md or a system-prompt file |
| `system-prompt.md` | A short version (<1,500 characters) for small instruction boxes, like ChatGPT |
| `configs/claude_desktop_config.json` | MCP servers for Claude Desktop |
| `configs/cursor-mcp.json` (also `.cursor/mcp.json`) | MCP servers for Cursor |
| `configs/claude-code.mcp.json` (also `.mcp.json`) | MCP servers for Claude Code |
| `configs/vscode-mcp.json` | MCP servers for VS Code (`.vscode/mcp.json`) |
| `configs/generic-mcp.json` | Plain server list for any other MCP client |
| `.claude-plugin/` | Makes the folder a Claude Code plugin (skill and servers in one install) |
| `scripts/build.sh` | Regenerates `AGENTS.md` and the skill zip after you edit `SKILL.md` |

## The connectors

| App | How Bachat Bhai reaches it | Address |
|---|---|---|
| Zepto | Official MCP connector | `https://mcp.zepto.co.in/mcp` |
| Swiggy Instamart | Official MCP connector | `https://mcp.swiggy.com/im` |
| Blinkit | Its normal website, through a browser tool (optional) | `npx @playwright/mcp@latest` |
| Flipkart Minutes | Its normal website, through a browser tool (optional) | same |

Both connectors sign you in with **your phone number and OTP** on Zepto's or Swiggy's own login page. Your AI app keeps the login; this pack never sees it.

**No browser tool?** That's fine. Bachat Bhai compares Zepto and Instamart only, and tells you so.

**Needs Node.js** (free, [nodejs.org](https://nodejs.org), LTS version) for anything started with `npx`: the browser tool, and `mcp-remote` in Claude Desktop and Cursor. `mcp-remote` is the small open-source bridge that both Zepto's and Swiggy's own setup guides use for Claude Desktop.

## 2-minute setup

### Claude Desktop (Free, Pro, Max, Team)

1. Install Node.js if you don't have it.
2. In Claude Desktop, open **Settings → Developer → Edit Config**. This opens `claude_desktop_config.json` (macOS: `~/Library/Application Support/Claude/`, Windows: `%APPDATA%\Claude\`).
3. Paste the `mcpServers` block from [`configs/claude_desktop_config.json`](configs/claude_desktop_config.json). If the file already has an `mcpServers` block, add the three entries inside it. Save, then **quit and reopen** Claude.
4. A browser tab opens for Zepto and one for Swiggy. Log in with your phone number and OTP.
5. Add the skill: **Settings → Capabilities**, turn on **Code execution and file creation**. Then **Customize → Skills → + → Upload a skill**, and choose the zip you get from **[⬇ Download bachat-bhai-skill.zip](https://github.com/amishah1998/bachat-bhai/raw/main/dist/bachat-bhai-skill.zip)**. Don't unzip it.
   No skills option? Create a **Project** and paste `AGENTS.md` into its instructions.
6. Say: "Bachat Bhai, compare: tomato, onion, paneer, atta".

*No Node.js?* Use **Customize → Connectors → + → Add custom connector** with the two connector URLs above instead of steps 2-4. The Free plan allows only **one** custom connector, and there's no browser tool this way, so you'd compare fewer apps.

### Claude Code

Either install the pack as a plugin (skill and all three servers in one go):

```bash
claude plugin marketplace add amishah1998/bachat-bhai
claude plugin install bachat-bhai@bachat-bhai
```

…or set it up by hand:

```bash
claude mcp add --transport http --scope user zepto https://mcp.zepto.co.in/mcp
claude mcp add --transport http --scope user swiggy-instamart https://mcp.swiggy.com/im
claude mcp add --scope user playwright -- npx -y @playwright/mcp@latest
git clone https://github.com/amishah1998/bachat-bhai && cd bachat-bhai
mkdir -p ~/.claude/skills && cp -r skills/bachat-bhai ~/.claude/skills/
```

Then start `claude`, run `/mcp`, and pick **Authenticate** for zepto and swiggy-instamart (phone + OTP in your browser). For a one-off session without installing anything: `claude --plugin-dir ./bachat-bhai` from the folder you cloned.

### Cursor

1. Copy the servers from [`configs/cursor-mcp.json`](configs/cursor-mcp.json) into `~/.cursor/mcp.json` (all projects) or into a project's `.cursor/mcp.json`. Opening this pack folder in Cursor also works, because it already has `.cursor/mcp.json` and `AGENTS.md`.
2. Copy the skill: `mkdir -p ~/.cursor/skills && cp -r skills/bachat-bhai ~/.cursor/skills/`.
3. Open **Cursor Settings → Tools & MCP**, check that the three servers are on, and click **Connect/Login** where asked. Log in with phone + OTP.
4. In Agent chat: "compare my grocery list: milk, bread, eggs".

Zepto goes through `mcp-remote` in Cursor, because Zepto's login currently only accepts Claude's and localhost return addresses (that's what Zepto's own guide uses).

### VS Code (Copilot agent mode)

Copy [`configs/vscode-mcp.json`](configs/vscode-mcp.json) to `.vscode/mcp.json` in your workspace (or run **MCP: Open User Configuration** and paste the `servers` block). Start the servers from the MCP view and log in when asked. Put `AGENTS.md` at the workspace root, or copy `skills/bachat-bhai` into `.github/skills/` if your version supports skills.

### ChatGPT (limited, web)

ChatGPT can only use remote connectors, so **Blinkit and Minutes aren't possible there**. Custom MCP apps need developer mode, which depends on your plan and region, and the menu names keep changing.

1. Find the custom-app option: **Settings → Apps** (or Plugins) → **Create**, or turn on **Developer mode** under Advanced if your account shows it.
2. Add Instamart: URL `https://mcp.swiggy.com/im`, authentication **OAuth**, then log in with phone + OTP.
3. Try Zepto the same way with `https://mcp.zepto.co.in/mcp`. Zepto lists ChatGPT support as beta, so it may not log in yet.
4. Create a **Project**, paste `system-prompt.md` into its instructions, and upload `AGENTS.md` as a project file.

Some plans only allow read actions. You'll still get the comparison, but filling the cart may not work.

### Any other MCP client

Add the two connectors as **Streamable HTTP** servers (see [`configs/generic-mcp.json`](configs/generic-mcp.json)). They use standard MCP OAuth 2.1: PKCE, dynamic client registration and a localhost callback. If your client only runs local (stdio) servers, use `npx -y mcp-remote <url>` instead, as in `configs/claude_desktop_config.json`. Load `AGENTS.md` (or `SKILL.md`) as the system prompt or instructions.

## About the browser tool (Blinkit, Flipkart Minutes)

- `@playwright/mcp` is Microsoft's free, open-source browser tool. It opens a real browser window **on your computer**, and Bachat Bhai uses blinkit.com and flipkart.com the same way you would.
- It uses Google Chrome by default. If you don't have Chrome, add `"--browser", "msedge"` (or `"firefox"`) to its `args`.
- **You** log in to Blinkit or Flipkart in that window if a site asks. Bachat Bhai never types passwords, OTPs or card numbers.
- Logins are kept in the tool's own browser profile, separate from your normal browser, so you sign in once. To have it forget everything when it closes, add `"--isolated"` to its `args`.
- Flipkart Minutes is reached at flipkart.com with `marketplace=HYPERLOCAL` in the address, at your pinned delivery location.

## Safety promises

- **Never orders or pays without your explicit yes** for that exact cart, app, address and payment method. Orders are real and cost real money.
- **Never invents prices.** Every number comes from the app, right then. Anything it couldn't read is marked "not checked" or "estimated".
- **Doesn't overwrite a cart you're using**, and doesn't touch one that's mid-checkout. Clears its own items from the other apps' carts when you ask.
- **Official sources only:** official connectors and the apps' own websites, at normal personal volume. No scrapers, no bulk crawling, no unofficial APIs.
- **Your data stays with you.** No server, no analytics. The pack contains no personal data, and the savings card never includes your name, address, phone number or order ids.
- Instamart payment is **UPI or Cash on Delivery**. A UPI QR expires in about 5 minutes, and nothing is charged if it expires.

## What a result looks like

> **Instamart is cheapest: ₹642 vs Zepto ₹671 (save ₹29).**
> A table with Item, Qty, one column per app, each fee row and the Total, plus flags such as "late-night fee", "substitute", "not found", "max 1 per order", "add ₹38 for free delivery", and a split-cart option when that's cheaper.
>
> *(Example numbers, not real prices.)*

Then the savings card to share, shown only when at least two apps had complete bills:

```
Bachat Bhai saved me ₹29 🛒
Instamart ₹642 | Zepto ₹671
12 items, same cart, real bills
#BachatFlex
```

## Limits to know

- Results are only as good as what each app shows at that moment. Prices, fees and stock change within minutes, and every comparison carries a time stamp.
- Blinkit and Flipkart Minutes need the browser tool and a local AI app (Claude Desktop, Claude Code, Cursor, VS Code). Website changes can break them, in which case Bachat Bhai says "couldn't check" and compares the rest.
- Zepto and Swiggy decide who can use their connectors and which AI apps they accept. If a login fails, check their pages: [Zepto MCP](https://github.com/zeptonow/mcp), [Swiggy MCP](https://mcp.swiggy.com/builders).
- BigBasket isn't supported because it has no official connector.
- Not affiliated with or endorsed by Zepto, Swiggy, Blinkit, Flipkart, Anthropic, OpenAI or Cursor.

## Customising

Edit `skills/bachat-bhai/SKILL.md`, then run `bash scripts/build.sh` to regenerate `AGENTS.md` and `dist/bachat-bhai-skill.zip`.

## Credits and license

Created by Ami and Karan. Released under the [MIT License](LICENSE). Share your savings with **#BachatFlex**.
