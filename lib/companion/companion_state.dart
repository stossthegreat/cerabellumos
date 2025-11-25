/// Companion State Enum - ALL 18 STATES
/// DO NOT modify, rename, or reorder

enum CompanionState {
  neutral_default,

  mouth_A_1,
  mouth_A_2,
  mouth_A_3,
  mouth_A_4,

  mouth_O_1,
  mouth_O_2,

  mouth_E_1,
  mouth_E_2,
  mouth_E_3,

  smile_soft,
  smile_big,
  smile_confident,

  eyes_closed_1,
  eyes_closed_2,
  eyes_closed_soft,

  serious_1,
  serious_2,
}

/// Frame mapping - EXACT paths, DO NOT change
const companionFrames = {
  CompanionState.neutral_default: 'assets/companion/neutral_default.png',

  CompanionState.mouth_A_1: 'assets/companion/mouth_A_1.png',
  CompanionState.mouth_A_2: 'assets/companion/mouth_A_2.png',
  CompanionState.mouth_A_3: 'assets/companion/mouth_A_3.png',
  CompanionState.mouth_A_4: 'assets/companion/mouth_A_4.png',

  CompanionState.mouth_O_1: 'assets/companion/mouth_O_1.png',
  CompanionState.mouth_O_2: 'assets/companion/mouth_O_2.png',

  CompanionState.mouth_E_1: 'assets/companion/mouth_E_1.png',
  CompanionState.mouth_E_2: 'assets/companion/mouth_E_2.png',
  CompanionState.mouth_E_3: 'assets/companion/mouth_E_3.png',

  CompanionState.smile_soft: 'assets/companion/smile_soft.png',
  CompanionState.smile_big: 'assets/companion/smile_big.png',
  CompanionState.smile_confident: 'assets/companion/smile_confident.png',

  CompanionState.eyes_closed_1: 'assets/companion/eyes_closed_1.png',
  CompanionState.eyes_closed_2: 'assets/companion/eyes_closed_2.png',
  CompanionState.eyes_closed_soft: 'assets/companion/eyes_closed_soft.png',

  CompanionState.serious_1: 'assets/companion/serious_1.png',
  CompanionState.serious_2: 'assets/companion/serious_2.png',
};

