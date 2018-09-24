var ImageComponent = React.createClass({
  getDefaultProps: function() {
    return {
      name: '',
      maxFiles: 1,
      onChange: function() { return true },
      onStart: function() { return true },
      onValidate: function() { return true },
      error_message: 'Invalid image - please try again',
      preview: false,
      value: null
    }
  },
  getInitialState: function() {
    return { value: this.props.value,
             previousValue: null,
             is_saving: false }
  },
  handleError: function(file) {
    var message = 'Could not save that image'
    if( file.xhr ) message = JSON.parse(file.xhr.response).error
    swal({ title: 'Uh Oh!', text: message })

    this.handleChange(this.state.previousValue)
    this.setState({ value: this.state.previousValue,
                    previousValue: null,
                    is_saving: false })
    this.dropzone.removeAllFiles()
    this.props.onValidate(false, this.props.error_message)
  },
  handleThumbnail: function(file, dataURL) {
    if( this.state.is_saving ) this.setState({ value: dataURL })
  },
  handleSuccess: function(file) {
    this.handleChange(JSON.parse(file.xhr.response).path)
    this.props.onValidate(true)
  },
  handleChange: function(url) {
    this.props.onChange({ target: { value: url, name: this.props.name } })
    this.setState({ value: url })
  },
  handleClear: function(event) {
    vgConfirm('Are you sure you want to remove this image?', function(confirmed) {
      if( !confirmed ) return

      this.handleChange(null)
      this.setState({ value: null })
    }, this)

    event.preventDefault()
  },
  handleStart: function(event) {
    this.setState({ previousValue: this.state.value, is_saving: true })
    this.props.onStart()
  },
  pathname: function() {
    return document.location.pathname.toString()
  },
  include_guide_resource: function() {
    var match = this.pathname().match(/\/guides\/(\d+)/)
    if( match && match.length > 1 ) return '?guide_id='+match[1]
    return ''
  },
  initDropZone: function() {
    var domNode = ReactDOM.findDOMNode(this.refs.dropzone),
        config = {
          headers: {
            'X-CSRF-Token': CSRF.token(),
            'Accept': 'application/json'
          },
          paramName: "upload[file]",
          maxFiles: this.props.maxFiles,
          previewTemplate: '<div></div>',
          url: '/uploads' + this.include_guide_resource()
        }

    this.dropzone = new Dropzone(domNode, config)
    this.dropzone.on('thumbnail', this.handleThumbnail)
    this.dropzone.on('success', this.handleSuccess)
    this.dropzone.on('error', this.handleError)
    this.dropzone.on('addedfile', this.handleStart)
  },
  componentDidMount: function() {
    this.initDropZone()
  },
  render: function() {
    var preview =  '',
        clear = ''

    if( this.props.preview && this.state.value ) {
      preview = <div style={{ backgroundImage: "url("+this.state.value+")" }}
                     className="img profile"></div>
    }
    if( this.state.value ) {
      var text = this.props.preview ? '' : ' Clear Image'
      clear = <a href="#" className='remove' onClick={this.handleClear}>
                <i className="fa fa-times" />{ text }
              </a>
    }
    return <div>
      <div ref="dropzone" className='drop--zone image--field'>
        { clear }
        { preview }
      </div>
      <span>{ this.props.placeholder }</span>
    </div>
  }
})
