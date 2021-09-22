shared_examples_for :unauthenticated_user do
  specify do
    subject
    expect(response.status).to eq(401)
    expect(json).to eq({
      "type" => 'authentication_error',
      "message" => "Invalid token"
    })
  end
end

shared_examples_for :unauthorized_user do
  specify do
    subject
    expect(response.status).to eq(401)
    expect(json).to eq({
      "type" => 'authorization_error',
      "message" => "You are not authorized to perform this action"
    })
  end
end
