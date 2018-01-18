var HalfMeasure = React.createClass({
  mixins: [HandleChange, Template],
  getDefaultProps: function() {
    return { id: false,
             title: '',
             description: '',
             stance: null,
             yes_means: '',
             no_means: '',
             endorsements: [],
             tags: [] }
  },
  removeTag: function(tag) {
    var tags = _.without(this.props.tags, _.find(this.props.tags, { name: tag }))
    this.setChangedState({ tags: tags })
  },
  addTag: function(tag) {
    var tags = this.state.tags
    tags.push({ name: tag, tagged_id: this.props.id, tagged_type: 'measure' })
    this.setChangedState({ tags: tags })
  },
  onChange: function(event) {
    this.handleChange(event.target.name, event.target.value)
  },
  handleRecommend: function(event) {
    var stance = event.target.value
    this.handleChange('stance', stance === '' ? null : stance)
    if( stance === '' ) return

    this.handleChange(
      'endorsements',
      _.filter(this.state.endorsements, { stance: stance })
    )
  },
  recommendedTitle: function() {
    if( !this.state.stance ) return "You Are Staying Neutral Because..."
    return {
      for: "You Are Voting Yes Because...",
      against: "You Are Voting No Because...",
    }[this.state.stance]
  },
  recommendedPlaceholder: function() {
    if( !this.state.stance ) return "We're meh on this measure because"
    return {
      for: "We love this and you should vote for it because...",
      against: "This measure is a trash fire and you should vote against it because...",
    }[this.state.stance]
  },
  maxEndorsements: function() {
    return this.state.stance ? 3 : 2
  },
  recommender: function() {
    var options = [{ text: 'Neutral', value: '' },
                   { text: '👍 Vote Yes', value: 'for' },
                   { text: '👎 Vote No', value: 'against' }]

    return <SelectComponent options={options}
                            onChange={this.handleRecommend}
                            value={this.state.stance || ''} />
  },
  getInitialState: function() {
    return { title: this.props.title,
             description: this.props.description,
             stance: this.props.stance,
             yes_means: this.props.yes_means,
             no_means: this.props.no_means,
             endorsements: this.props.endorsements,
             tags: this.props.tags }
  },
  renderForEndorsements() {
    if( this.state.stance === 'against' ) return
    return <div className="mui-row mui-panel for--block">
      <h4>In Favor</h4>
      <Endorsements ref="yes_endorsements"
                    className="mui-col-md-5"
                    template={this.props.template}
                    endorsements={this.state.endorsements}
                    handleChange={this.handleChange}
                    endorsed_type='measure'
                    endorsed_id={this.props.id}
                    limit={this.template('measures.endorsements.limit')}
                    max={this.maxEndorsements()}
                    stance="for" />
    </div>
  },
  renderAgainstEndorsements() {
    if( this.state.stance === 'for' ) return
    return <div className="mui-row mui-panel against--block">
      <h4>Against</h4>
      <Endorsements ref="no_endorsements"
                    className="mui-col-md-5"
                    template={this.props.template}
                    endorsements={this.state.endorsements}
                    handleChange={this.handleChange}
                    endorsed_type='measure'
                    endorsed_id={this.props.id}
                    limit={this.template('measures.endorsements.limit')}
                    max={this.maxEndorsements()}
                    stance="against" />
    </div>
  },
  render: function() {
    return <div className="measure mui-col-md-11 measure--form">
      <div className="mui-row">
          <h3>Details</h3>
          <InputComponent name="title"
                          label="Ballot Measure Title"
                          ref="title"
                          placeholder="Ballot Measure 420"
                          value={ this.state.title }
                          onChange={ this.onChange }
                          limit={ this.template('measures.title.limit', 104) } />
          <InputComponent name="description"
                          element="textarea"
                          ref="description"
                          label="What it Does In 15 Words"
                          placeholder="This law outlaws ferrets OMG!"
                          value={ this.state.description }
                          onChange={ this.onChange }
                          limit={this.template('measures.description_15_words.limit')}/>
          <h3>Recommendation</h3>
          { this.recommender() }
          <InputComponent name="yes_means"
                          element="textarea"
                          ref="yes_means"
                          label={ this.recommendedTitle() }
                          placeholder={ this.recommendedPlaceholder() }
                          value={ this.state.yes_means }
                          onChange={ this.onChange }
                          limit={this.template('measures.description.limit')}/>
      </div>
      { this.renderForEndorsements() }
      { this.renderAgainstEndorsements() }
    </div>
  }
})
