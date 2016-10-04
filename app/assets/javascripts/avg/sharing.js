function log_share(method, type, thing) {
  try { ga('send', 'event', "share_"+method, type, thing) } catch(e) { }
}
function log_open_share(type, thing) {
  try { ga('send', 'event', 'share_open', type, thing); } catch(e) { }
}
function sharingWidget(container, log_it) {
  var button = document.createElement('a'),
      message = container.getAttribute('data-message') || defaultMessage,
      tags = container.getAttribute('data-tags'),
      category = container.getAttribute('data-category') || null,
      item = container.getAttribute('data-item') || 'share',
      link = container.getAttribute('data-link') || document.location.toString(),
      generic_link = document.createElement('a'),
      parent = container.parentElement

  generic_link.setAttribute('target','_blank')

  var facebook = generic_link.cloneNode(),
      twitter = generic_link.cloneNode(),
      tumblr = generic_link.cloneNode()
      email = generic_link.cloneNode()

  facebook.className = "fa fa-facebook"
  twitter.className = "fa fa-twitter"
  tumblr.className = "fa fa-tumblr"
  email.className = "fa fa-envelope-o"

  facebook.onclick = function() {
      log_share('facebook', category, name)
      this.className += ' clicked'
  }
  twitter.onclick = function() {
      log_share('twitter', category, name)
      this.className += ' clicked'
  }
  tumblr.onclick = function() {
      log_share('tumblr', category, name)
      this.className += ' clicked'
  }
  email.onclick = function() {
      log_share('email', category, name)
      this.className += ' clicked'
  }

  var track = (item.toLowerCase().replace(/[\uE000-\uF8FF]/g, '')
           .replace(/\s/g,'-'))


  var link_pieces = link.split('#')
  link = link_pieces[0]
  document_hash = link_pieces.length > 1 ? '#'+link_pieces[1] : ''

  if( !link.match(/http/) ) link = [document.location.protocol,
                                    '//',
                                    document.location.hostname,
                                    link]

  var link_pieces = link.split('?')
  link = link_pieces.shift()
  link_pieces.concat(['utm_source=share', 'utm_campaign='+track])
  link += '?' + link_pieces.join('&')

  function escape_add_medium_and_hash(medium) {
    return escape(link+'&utm_medium='+medium+document_hash)
  }

  var facebook_link = escape_add_medium_and_hash('facebook')
  facebook.setAttribute('href',
                        "https://www.facebook.com/sharer/sharer.php?u="+facebook_link)

  var tweet_params = ["text="+message,
                      "url="+escape_add_medium_and_hash('twitter'),
                      "hashtags="+hashtag,
                      "related="+related].join('&')
  twitter.setAttribute('href',
                        "https://twitter.com/intent/tweet?"+tweet_params)

  var tumblr_params = ["canonicalUrl="+escape_add_medium_and_hash('tumblr'),
                       "caption="+message,
                       "tags="+[defaultTags,tags].join(','),
                       "show-via=true"].join('&')
  tumblr.setAttribute('href',
                      "https://www.tumblr.com/widgets/share/tool?"+tumblr_params)

  var email_params = ["subject="+message,
                      "body="+escape_add_medium_and_hash('email')].join('&')
  email.setAttribute('href', "mailto:?"+email_params);

  container.appendChild(twitter)
  container.appendChild(facebook)
  container.appendChild(tumblr)
  container.appendChild(email)

  log_open_share(category, item)
}
