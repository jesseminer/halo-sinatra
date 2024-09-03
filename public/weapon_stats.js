WeaponStats = {
  template: '#weapon-stats-template',
  props: { playerId: Number },

  data () {
    return { gameMode: 'arena', weapons: [] }
  },

  computed: {
    filteredWeapons () {
      return this.weapons.filter(w => w.game_mode === this.gameMode)
    }
  },

  created () {
    this.loadWeapons()
  },

  methods: {
    loadWeapons () {
      fetch(`/weapon_usages?player_id=${this.playerId}`)
        .then(resp => resp.json())
        .then(weapons => this.weapons = weapons)
    }
  }
}
