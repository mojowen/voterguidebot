var Endorsements = React.createClass({
  mixins: [Template],
  getDefaultProps: function() {
    return { endorsements: [],
             stance: 'for',
             endorsed_id: false,
             endorsment_type: 'false',
             className: '',
             handleChange: function() { } }
  },
  qualifyingEndorsements: function() {
    return _.filter(this.props.endorsements, function(end) {
          return this.props.stance === end.stance
    }, this)
  },
  addEndorsement: function(event) {
    var endorsements = this.props.endorsements
    if( this.qualifyingEndorsements().length < this.props.template.endorsements.max ) {
      endorsements.push({
        endorser: '',
        endorsed_type: this.props.endorsed_type,
        endorsed_id: this.props.endorsed_id,
        stance: this.props.stance
      })
      this.props.handleChange('endorsements', endorsements)
    }
    event.preventDefault()
  },
  removeEndorsement: function(event) {
    var index = event.currentTarget.getAttribute('data-index'),
        endorsements = _.without(this.props.endorsements,
                                 this.props.endorsements[index])

    this.props.handleChange('endorsements', endorsements)
    event.preventDefault()
  },
  handleChange: function(event) {
    var field = event.target.name,
        index = event.target.getAttribute('data-index'),
        value = this.props.endorsements

    value[index].endorser = event.target.value

    this.props.handleChange('endorsements', value)
  },
  render: function() {
    var endorsements = _.map(this.props.endorsements, function(endorsement, index) {
          if( this.props.stance !== endorsement.stance ) return ''
          var after = <a className="remove"
                         onClick={this.removeEndorsement}
                         data-index={index} >
                          <i className="fa fa-times" />
                      </a>
          return <li key={'endorsement_'+index} >
                  <InputComponent value={endorsement.endorser}
                                  name={'endorsement_'+index}
                                  data-index={index}
                                  onChange={this.handleChange}
                                  after={after} />
                 </li>
        }, this),
        addEndorsement = ''

    if( this.qualifyingEndorsements().length < this.props.template.endorsements.max ) {
      addEndorsement = <a className="add--endorsements"
                          onClick={this.addEndorsement}>
                          <i className="fa fa-plus-square" /></a>
    }

    return <div className={"endorsements " +this.props.className}>
      <strong>Supporters</strong>{ addEndorsement }
      <ul>{ endorsements }</ul>
    </div>
  }
})
