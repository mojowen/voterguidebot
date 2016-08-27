var Measure = React.createClass({
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
    event.preventDefault()
    var stance = event.currentTarget.getAttribute('data-stance')
    this.handleChange('stance', this.state.stance === stance ? null : stance)
  },
  recommender: function(stance) {
    var is_recommended = this.state.stance == stance,
        icon = is_recommended ? 'check-square-o' : '',
        className = is_recommended ? 'accent' : 'primary'
        text = is_recommended ? 'Recommended' : 'Recommend'

    return <div className="recommendation">
        <button className={"mui-btn mui-btn--small mui-btn--" + className}
                onClick={this.handleRecommend}
                data-stance={stance}>
          <i className={"fa fa-" +icon} />&nbsp;
          {text}
        </button>
      </div>
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
  render: function() {
    return <div className="measure mui-col-md-11 measure--form">
      <div className="mui-row">
          <h3>Details</h3>
          <InputComponent name="title"
                          label="Ballot Measure Title"
                          ref='title'
                          placeholder="Ballot Measure 420"
                          value={ this.state.title }
                          onChange={ this.onChange }
                          limit={this.props.template.measures.title.limit} />
          <InputComponent name="description"
                          element="textarea"
                          ref='description'
                          label="Description of Measure"
                          placeholder="This will finally legalize..."
                          value={ this.state.description }
                          onChange={ this.onChange } />
      </div>
      <div className="mui-row">
        <Taggable tags={this.state.tags}
                  id={this.props.id}
                  tagged_type='Ballot Measure'
                  available_tags={this.props.template.tags}
                  removeTag={this.removeTag}
                  addTag={this.addTag} />
      </div>
      <div className="mui-row mui-panel for--block">
        <h4>In Favor</h4>
        <InputComponent name="yes_means"
                        className="mui-col-md-6"
                        label="What happens if it passes?"
                        placeholder="Everything changes!"
                        element="textarea"
                        value={this.state.yes_means}
                        onChange={this.onChange} />
        <Endorsements ref="yes_endorsements"
                      className="mui-col-md-5"
                      template={this.props.template}
                      endorsements={this.state.endorsements}
                      handleChange={this.handleChange}
                      endorsed_type='measure'
                      endorsed_id={this.props.id}
                      stance="for" />
        { this.recommender('for') }
      </div>
      <div className="mui-row mui-panel against--block">
        <h4>Against</h4>
        <InputComponent name="no_means"
                        className="mui-col-md-6"
                        label="What happens if it does not pass?"
                        placeholder="Everything stays the same!"
                        element="textarea"
                        value={this.state.no_means}
                        onChange={this.onChange} />
        <Endorsements ref="no_endorsements"
                      className="mui-col-md-5"
                      template={this.props.template}
                      endorsements={this.state.endorsements}
                      handleChange={this.handleChange}
                      endorsed_type='measure'
                      endorsed_id={this.props.id}
                      stance="against" />
        { this.recommender('against') }
      </div>
    </div>
  }
})
