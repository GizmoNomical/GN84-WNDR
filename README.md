# GN84-WNDR Core Platform

Project Zomboid multiplayer server framework powering **The Wanderers** community server.

GN84-WNDR serves as the core gameplay and backend platform for a live multiplayer environment, providing economy systems, world persistence, synchronization infrastructure, administrative tooling, and real-time gameplay systems.

## Key Features

- Server-authoritative multiplayer architecture
- Client-server synchronization systems
- Persistent world and object data
- Dual-currency economy infrastructure
- Recycler system with concurrency protection
- Persistent audio emitter framework
- Administrative management tools
- Event-driven architecture focused on performance

## Technical Highlights

- Lock-state and timeout handling for shared world interactions
- Anti-desync safeguards for multiplayer gameplay systems
- Persistent data management using ModData
- Real-time synchronization of world state across connected clients
- Performance-focused event-driven design to minimize server overhead

## Problems Solved

- Prevented multiplayer desynchronization through server-authoritative state handling.
- Eliminated concurrent access issues on shared world entities using lock-state and timeout controls.
- Reduced server overhead through event-driven systems that avoid constant polling.

## Live Environment

This platform has been actively maintained and expanded through live multiplayer operation, supporting persistent progression, economy systems, and server-wide gameplay features.

## Technologies

- Lua (Kahlua)
- Project Zomboid Mod API
- Client-Server Architecture
- Event-Driven Systems
- Persistent Data Management

## Status

Actively maintained and expanded.

## Dual Currency Economy & Shop
<img width="2560" height="1361" alt="screenshot_28-05-2026_22-09-51" src="https://github.com/user-attachments/assets/d3e7bfd9-f265-4177-8bbb-46c382aa012e" />

## Money Clip - Currency Tracking
<img width="2560" height="1361" alt="screenshot_28-05-2026_22-10-01" src="https://github.com/user-attachments/assets/f12349b7-0cc6-46e0-9b0e-74c320be5f53" />

## Money Clip - Adjustable Settings & Currency Consolidation
<img width="2560" height="1361" alt="screenshot_28-05-2026_22-10-11" src="https://github.com/user-attachments/assets/df5a17a0-aa67-4277-86ad-4c33be1a490e" />

## Admin Currency Creation Tools
<img width="2560" height="1361" alt="screenshot_28-05-2026_22-09-27" src="https://github.com/user-attachments/assets/a15cc958-f94e-4eda-b1ac-b70782ba52d1" />

## Recycler System
<img width="2560" height="1361" alt="screenshot_28-05-2026_22-08-43" src="https://github.com/user-attachments/assets/761323d2-4099-4fc7-87cd-d82f4b113bde" />

## In-Game Lotto System - Scratch-It Tickets
<img width="2560" height="1361" alt="screenshot_28-05-2026_22-14-18" src="https://github.com/user-attachments/assets/3a2130bb-2c98-4308-9d95-591e513b4ee2" />

## Server-Side Tracking of Economy and Lottery Systems
<img width="1859" height="1004" alt="Screenshot 2026-05-28 221851" src="https://github.com/user-attachments/assets/b21e6089-896b-4e40-a120-6ac5a6545739" />



