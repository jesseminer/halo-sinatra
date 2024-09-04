WeaponStats = {
  template: '#weapon-stats-template',
  props: { playerId: Number },

  data () {
    return { gameMode: 'arena', showPower: false, weapons: [] }
  },

  computed: {
    filteredWeapons () {
      return this.weapons.filter(w => {
        return w.game_mode === this.gameMode && (this.showPower || w.weapon_type === 'Standard')
      })
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
