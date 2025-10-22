# 🌍 United Pixels

> Learn Model UN by playing. Practice IRC procedures, public speaking, and diplomatic negotiation with AI delegates before your first real session.

[![Development Status](https://img.shields.io/badge/status-in%20development-yellow)]()
[![License](https://img.shields.io/badge/license-MIT-blue)]()

---

## What is this?

**United Pixels** is an educational game that simulates International Relations Committee (IRC) sessions. Players learn parliamentary procedures, negotiation tactics, and public speaking skills by engaging with AI-powered country delegates.

**Perfect for:**
- Students preparing for their first Model UN session
- Anyone interested in international relations and diplomacy
- Practicing public speaking in a low-stakes environment

---

## Key Features

- 🎤 **Voice/Text Input** - Practice speeches with real-time feedback on eloquence and diplomatic language
- 🤖 **AI Delegates** - Negotiate with 3+ countries, each with unique personalities and hidden agendas
- 📜 **Authentic Procedures** - Learn real IRC mechanics: motions, caucuses, POIs, and voting
- ✍️ **Resolution Building** - Draft UN-style resolutions with guided clause templates
- 🎓 **Tutorial Mode** - Step-by-step introduction to all mechanics

---

## Quick Start

### For Players

**Play Online:** [Coming Soon]

**System Requirements:**
- Internet connection (for AI features)
- Microphone (optional, for voice input)
- Modern browser or download desktop version

### For Developers

[Coming Soon]

**Required API Keys:**
- Google Gemini API (free tier) - [Get here](https://ai.google.dev/)
- OpenAI Whisper API (optional) - [Get here](https://platform.openai.com/)

---

## How It Works

### The Five Phases

1. **Setup** (2-3 min) - Choose topic, review country brief
2. **Opening Statements** (5-10 min) - All countries present their positions
3. **Discussion** (10-15 min) - Moderated/unmoderated caucuses, POIs, motions
4. **Resolution Writing** (5-8 min) - Draft solutions with your coalition
5. **Voting** (3-5 min) - Vote on resolutions to reach consensus

**Session Duration:** 25-35 minutes

---

## Tech Stack

**Frontend:** Unity (C#) / JavaScript + React  
**AI:** Google Gemini API, Ollama (local fallback)  
**Speech:** Web Speech API / Whisper API  
**Data:** JSON (country profiles, topics, clauses)

---

## Current Project Structure

```
res/
├── scenes/          # Game components,
├── scripts/            # AI integration, prompts, personalities, Scoring, relationships, voting logic
├── assets/            # User interface components, audio
├── resources/         # themes, dialogues
├── shaders/          #
└── addons/         # Dialogic, wakatime
```

---

## Current Status

**Sprint:** Week 1 - Foundation & Prototyping  
**Next Milestone:** Playable vertical slice (Week 4)

| Feature | Status |
|---------|--------|
| Core game loop | 🟡 In Progress |
| AI delegates | 🟡 In Progress |
| Speech input | 🟡 In Progress |
| Tutorial mode | 🔴 Not Started |
| Beta testing | 🔴 Not Started |

---

## Contributing

We welcome contributions! Focus areas:
- 🌍 Additional countries/topics
- 🧪 Test coverage
- 📚 Documentation
- ♿ Accessibility improvements

**Process:** Fork → Branch → PR. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## Team

- **Project Lead:** [Benie Gouli]
- **Technical Lead:** [Name]
- **AI Specialist:** [Name]
- **Game Designer:** [Name]
- **UI/UX Designer:** [Name]

**Advisors:** IRC Club at [University Name]

---

## Roadmap

**v1.0 (Week 12)** - Launch with 3 topics, 10 countries, tutorial mode  
**v1.1 (Month 2)** - Bug fixes, balance, performance  
**v1.5 (Month 6)** - 2 new topics, challenge mode, achievements  
**v2.0 (Future)** - Multiplayer, mobile, VR, custom scenarios

---

## License

MIT License - See [LICENSE](LICENSE) for details.

---

## Contact

- **Email:** united.pixels.game@gmail.com
- **Issues:** [GitHub Issues](https://github.com/your-team/united-pixels/issues)
- **Discord:** [Coming Soon]

---

<div align="center">

**Made with ❤️ by the IndiGenius Team**

*Empowering the next generation of diplomats through play*

[⬆ Back to Top](#-united-pixels)

</div>
