# Casino Roulette Betting Strategy Simulator 🎰

A mathematical Monte Carlo style roulette simulator written in pure Bash that models betting algorithms to analyze capital volatility and demonstrate probability theory against the house edge.

## Implemented Strategies

- **Martingale Strategy:** Exponentially doubles the wager following every loss until a win resets the bet to its base value.
- **Reverse Labouchere (Split Martingale):** Manages dynamic positive-progression betting sequences with automated profit ceilings and risk-mitigation floor adjustments.

---

## ✨ Features

### Martingale Simulation:
- Continuous betting on even-money propositions (**even/odd**).
- Automatic bankroll calculation and bet doubling.
- Post-simulation metrics:
  - Total rounds played before bankruptcy.
  - History of consecutive losing numbers.
  - Peak bankroll balance reached.

### Reverse Labouchere:
- Dynamic array sequence manipulation (`[1 2 3 4]`).
- Configurable profit threshold to trigger sequence resets.
- Dynamic ceiling re-adjustments when reaching critical drawdowns.
- Sequence tracking:
  - Maximum sequence expansion recorded.
  - Real-time sequence adjustments per spin.

---

## 🎲 Usage

```bash
chmod +x casino_roulette_simulator.sh
./casino_roulette_simulator.sh -m [initial_balance] -t [strategy]
```
### Parameters
- -m: Initial bankroll amount.
- -t: Strategy to execute (martingale or inverseLabouchere).
- -h: Show help panel.
## Example 
`./casino_roulette_simulator.sh -m 500 -t martingale`

## Operational Notes
- Incorporates ANSI terminal formatting for readability.
- Loops autonomously until bankroll depletion (balance <= 0).
- Supports graceful termination via SIGINT (Ctrl+C).
