var Taggable = React.createClass({
  getDefaultProps: function() {
    return { tags: [],
             template_tags: [],
             addTag: function() {},
             removeTag: function() {} }
  },
  handleRemoveClick: function(event) {
    this.props.removeTag(event.currentTarget.getAttribute('data-tag'))
    event.preventDefault()
  },
  handleChange: function(event) {
    var val = event.target.value
    if( val ) this.props.addTag(val)
  },
  render: function() {
    var add_tags = '',
        tags = _.map(this.props.tags, function(tag) {
            var key = ['tag', tag.name, this.props.id].join('_')
            return <div className="tag" key={key}>
              {tag.name}
              <a href="#" data-tag={tag} onClick={this.handleRemoveClick}>
                <i className="fa fa-times"/>
              </a>
            </div> }, this),
        tag_options = _.difference(this.props.template_tags,
                                   _.map(this.props.tags, 'name'))

    if( tag_options.length > 0 ) {
      tag_options = _.map(tag_options, function(tag) {
                          var key = ['option', tag, this.props.id].join('_')
                          return <option key={key}>{ tag }</option> }, this)

      var add_tags = <div className="tags--select mui-select">
        <select onChange={this.handleChange}>
          <option>Tag Question &#187;</option>
          { tag_options }
        </select>
      </div>
    }

    return <div className="tags">
      <strong>Tags:</strong>
      { tags }
      { add_tags }
    </div>
  }
})
