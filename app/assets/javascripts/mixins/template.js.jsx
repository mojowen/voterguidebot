var Template = {
  getDefaultProps: function() {
    return {
      template: {
        tags: [],
        questions: {
          max: 7,
          text: { limit: 140 },
          samples: []
        },
        endorsements: {
          max: 3
        }
      }
    }
  }
}
