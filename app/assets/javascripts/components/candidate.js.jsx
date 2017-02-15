var Candidate = React.createClass({
  mixins: [Template, Draggable],
  getDefaultProps: function() {
    return { name: '',
             party: '',
             bio: '',
             photo: '',
             id: '',
             endorsements: [],
             start_open: false,
             disable_close: false,
             candidates: [],
             handleChange: function() {} }
  },
  getInitialState: function() {
    return { open: this.props.start_open }
  },
  handleChange: function(event) {
    var field = event.target.name,
        value = event.target.value,
        candidates = this.props.candidates

    candidates[this.props.index][field] = value
    this.props.handleChange('candidates', candidates)
  },
  handleRemove: function(event) {
    event.preventDefault()

    var candidates = this.props.candidates,
        candidate = candidates[this.props.index]

    vgConfirm('Are you sure you want to remove this candidate?', function(confirmed) {
      if( !confirmed ) return
      this.props.handleChange('candidates', _.without(candidates, candidate))
    }, this)
  },
  handleEndorsementChange: function(field, value) {
    var candidates = this.props.candidates

    candidates[this.props.index][field] = value
    this.props.handleChange('candidates', candidates)
  },
  handleDragOver: function(current_id, replaced_id) {
    var candidates = this.props.candidates,
        current = candidates[current_id],
        replaced = candidates[replaced_id]

    candidates[replaced_id] = current
    candidates[current_id] = replaced
    this.props.handleChange('candidates', candidates)
  },
  openCandidate: function(event) {
    this.setState({ open: !this.state.open })
    event.preventDefault()
  },
  holdOpen: function() {
    this.setState({ disable_close: true })
  },
  handleUpload: function(event) {
    this.handleChange(event)
    this.setState({ disable_close: false })
  },
  render: function() {
    var candidateClassNames = ['candidate--form',
                               'mui-col-md-5',
                               'mui-col-md-offset-1',
                               'mui-panel']

    if( this.state.open ) {
      candidateClassNames.push('open')
      var button = 'Done',
          icon = 'check'
          guts = <div>
            <InputComponent label="Name"
                            placeholder="Joe Smith"
                            value={this.props.name}
                            name="name"
                            onChange={this.handleChange}
                            limit={this.template('candidates.name.limit')} />
            <InputComponent label="photo"
                            element="ImageComponent"
                            value={this.props.photo}
                            name="photo"
                            preview={true}
                            onStart={this.holdOpen}
                            onChange={this.handleUpload} />
            <InputComponent label="Party"
                            placeholder="Working Families Party"
                            value={this.props.party}
                            name="party"
                            onChange={this.handleChange}
                            limit={this.template('candidates.party.limit')} />
            <InputComponent label="Bio"
                            placeholder="Paper towel preserver, motorcycle rider, etc."
                            value={this.props.bio}
                            element="textarea"
                            name="bio"
                            onChange={this.handleChange}
                            limit={this.template('candidates.bio.limit')} />
            <strong>Links</strong>
            <div className="social">
              <InputComponent placeholder="http://candidate-website.pizza"
                              value={this.props.website} name="website" type="url"
                              onChange={this.handleChange} fa="link" />
              <InputComponent placeholder="http://facebook.com/candidate-name"
                              value={this.props.facebook} name="facebook" type="url"
                              onChange={this.handleChange} fa="facebook-square" />
              <InputComponent placeholder="http://twitter.com/the-real-candidate"
                              value={this.props.twitter} name="twitter" type="url"
                              onChange={this.handleChange} fa="twitter-square" />
            </div>
            <Endorsements ref="endorsements"
                          endorsements={this.props.endorsements}
                          handleChange={this.handleEndorsementChange}
                          template={this.props.template}
                          endorsed_type='candidate'
                          endorsed_id={this.props.id}
                          limit={this.template('candidates.supporters.limit')}
                          limit={this.template('candidates.supporters.max')} />
          </div>
      if( this.state.disable_close ) {
        icon = 'save fa-pulse',
        button = ' Saving'
      }
    } else {
      guts = <SmallCandidate {...this.props} />
      icon = 'pencil',
      button = 'Edit'
    }

    return <div className={candidateClassNames.join(' ')} {...this.draggable_props()} >
      <i className="fa fa-times remove--candidate" onClick={ this.handleRemove } />
      { this.draggable() }
      { guts }
      <div className="edit--wrap">
        <button className="mui-btn mui-btn--small mui-btn--primary"
           disabled={this.state.disable_close}
           onClick={this.openCandidate} >
            <i className={"fa fa-"+icon} />
            { button }
        </button>
      </div>
    </div>
  }
})
