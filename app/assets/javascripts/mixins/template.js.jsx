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
        measures: {
          title: { limit: 104 }
        },
        endorsements: {
          max: 3
        }
      }
    }
  }
}
