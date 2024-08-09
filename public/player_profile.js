PlayerProfile = {
  template: '#player-profile-template',
  components: { PlaylistRanks, ServiceRecord },
  props: { playerProfile: Object, seasons: Array },

  data () {
    return { player: this.playerProfile }
  },

  created () {
    if (!this.player.refreshed_at) { this.updatePlayer() }
  },

  methods: {
    updatePlayer () {
      fetch(`/players/${this.player.id}/fetch`, { method: 'PUT' })
        .then(resp => resp.json())
        .then(player => this.player = player)
    }
  }
}
