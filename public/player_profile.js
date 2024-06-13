PlayerProfile = {
  template: '#player-profile-template',
  props: { player: Object },

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
