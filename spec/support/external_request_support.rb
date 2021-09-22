module ExternalRequestSupport extend self

  def mock_success_page_request(url, parsed = true)
    response = parsed ? success_response_body : fail_response_body
    mock_request url, 200, 'text/html; charset=utf-8', response
  end

  def mock_success_image_request(url)
    mock_request url, 200, 'image/jpeg'
  end

  def mock_success_pdf_request(url)
    mock_request url, 200, 'application/pdf'
  end

  def mock_failed_request(url)
    mock_request url, 404, 'text/html; charset=utf-8'
  end

  def mock_remote_image(url)
    WebMock::API.stub_request(:get, url).with(
    :headers => {
      'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"CarrierWave/#{CarrierWave::VERSION}"
    }).to_return({
      status: 200,
      headers: { 'Content-Type' => 'image/png' },
      body: File.read(Rails.root.join('spec', 'assets', 'avatar.png'))
    })
  end

  def mock_request(url, status, type, body = '')
    WebMock::API.stub_request(:get, url).to_return({
      status: status,
      headers: content_type(type),
      body: body
    })
  end

  def content_type(type)
    { 'Content-Type' => type }
  end

  def success_response_body
    '<html>
      <head>
        <title>GitHub · How people build software</title>
        <meta property="description" content="GitHub is where people build software.">
        <meta property="og:title" content="Build software better, together">
        <meta property="og:image" content="https://assets-cdn.github.com/images/modules/open_graph/github-logo.png">
        <meta property="og:description" content="GitHub is where people build software.">
      </head>
      <body>
      </body>
    </html>'
  end

  def fail_response_body
    '<html>
      <head>
        <title>Some title</title>
        <meta property="og:title" content="Build software better, together">
        <meta property="og:image" content="https://assets-cdn.github.com/images/modules/open_graph/github-logo.png">
      </head>
      <body>
      </body>
    </html>'
  end
end
