PlaylistRanks = {
  template: '#playlist-ranks-template',
  props: { playerId: Number, seasons: Array },

  data () {
    return { ranks: [], selectedSeasonId: this.seasons[0].id }
  },

  created () {
    this.loadRanks()
  },

  watch: {
    selectedSeasonId () { this.loadRanks(true) }
  },

  methods: {
    loadRanks (refresh = false) {
      fetch(`/playlist_ranks?player_id=${this.playerId}&season_id=${this.selectedSeasonId}&refresh=${refresh}`)
        .then(resp => resp.json())
        .then(ranks => this.ranks = ranks)
    }
  }
}
