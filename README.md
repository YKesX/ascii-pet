# ascii-pet
A terminal based ascii-pet, just for fun
# 🐾 ASCII Pet Terminal Game

A terminal-based virtual pet simulation. 
Choose between a cat or a dog, give it a name, and take care of it! 
The pet reacts to how well (or poorly) you treat it. 
Featuring real-time need tracking and expressive ASCII visuals.

```
    /\_/\  
   ( ^ᴗ^ ) 
    > ~ <  
```

---

## 🎮 Features

- 🐶 Choose between a **Cat** or **Dog**
- 📝 Name your pet — it responds to you!
- 🕒 **Time-based needs**: Hunger, attention, and sleep
- 😾 Moods: Idle, Happy, Angry, Sleepy, Sleeping, Hungry, Wants Attention
- 💾 Save/load system — your pet remembers you!
- 🌀 Idle animations and pet behaviors
- 🎲 Random events: your pet may surprise you

- 💻 Fully rewritten in C++ (Because why not)
- 🪖 A little cut-down x86 Assembly version (Because i can)(i can't)

---

## 💡 How to Run

Make sure you have Python 3 installed.

```bash
python ascii_pet.py
```

Follow the on-screen prompts to:
1. Choose your pet (Cat or Dog)
2. Name it
3. Start caring for it!

---

## 🧠 Mood System Logic

| Mood             | Trigger                                                  |
|------------------|-----------------------------------------------------------|
| Angry            | Not fed for more than 29 hours / Insulted                |
| Hungry           | Not fed for more than 26 hours                           |
| Wants Attention  | Not petted for more than 6 hours                         |
| Sleepy           | Not slept for more than 1 hour                           |
| Sleeping         | Slept via user command, lasts 1 hour unless disturbed    |
| Happy            | After positive interaction, lasts for 30 minutes         |
| Idle             | Default state                                            |

---

## 📅 Project Status

- [x] Pet selection & naming
- [x] Real-time need tracking
- [x] Mood system with ASCII visuals
- [x] Save/Load system
- [x] Stat tracking dashboard
- [x] Random pet events
- [x] C++ port(Not Tested)
- [x] Assembly (x86) port(Not tested and nasm.us is down so can't test) (i hate this)
- [ ] Assembly (ARM) port
- [ ] Executable packaging
- [ ] Final touches & cleanup

---

## 🌟 Show Some Love
If you enjoyed this project:

⭐ Star it on GitHub

🐾 Fork it and create your own pet

🎨 Share new ASCII art or mood ideas

---

## 🤝 Contributing

Pull requests are welcome! If you’d like to contribute:

1.Fork the repo

2.Create a new branch (git checkout -b feature-name)

3.Commit your changes

4.Push to the branch (git push origin feature-name)

5.Open a Pull Request

---

## 👨‍💻 Author

Created with unnecessary time expenditure by [me](https://github.com/YKesX)

---

## 📝 License
This project is licensed under the GNU General Public License v3.0. You are free to use, modify, and distribute this project as long as you retain the same license and attribution.
