PlayerProfile = {
  template: '#player-profile-template',
  components: { PlaylistRanks, ServiceRecord, WeaponStats },
  props: { playerProfile: Object, seasons: Array },

  data () {
    return { loading: false, player: this.playerProfile }
  },

  created () {
    if (!this.player.refreshed_at) { this.updatePlayer() }
  },

  methods: {
    updatePlayer () {
      this.loading = true
      fetch(`/players/${this.player.id}/fetch`, { method: 'PUT' })
        .then(resp => resp.json())
        .then(player => {
          this.player = player
          this.loading = false
        })
    }
  }
}
