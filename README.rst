.. image:: https://img.shields.io/travis/TeleSign/ruby_telesign.svg
    :target: https://travis-ci.org/TeleSign/ruby_telesign

.. image:: https://img.shields.io/gem/v/telesign.svg
    :target: https://rubygems.org/gems/telesign

.. image:: https://img.shields.io/github/license/TeleSign/ruby_telesign.svg
    :target: https://github.com/TeleSign/ruby_telesign/blob/master/LICENSE

========
TeleSign
========

TeleSign provides the world’s most comprehensive approach to account security for Web and mobile applications.

For more information about TeleSign, visit the `TeleSign website <http://www.TeleSign.com>`_.

TeleSign REST API: Ruby SDK
---------------------------

**TeleSign web services** conform to the `REST Web Service Design Model
<http://en.wikipedia.org/wiki/Representational_state_transfer>`_. Services are exposed as URI-addressable resources
through the set of *RESTful* procedures in our **TeleSign REST API**.

The **TeleSign Ruby SDK** is a set modules and functions — a *Ruby Library* that wraps the
TeleSign REST API, and it simplifies TeleSign application development in the `Ruby programming language
<https://www.ruby-lang.org>`_. The SDK software is distributed on
`GitHub <https://github.com/TeleSign/ruby_telesign>`_ and also as a Ruby Gem using `Ruby Gems <https://rubygems.org>`_.

Documentation
-------------

Detailed documentation for TeleSign REST APIs is available in the `Developer Portal <https://developer.telesign.com/>`_.

Installation
------------

To install the TeleSign Ruby SDK:

.. code-block:: bash

    $ gem install telesign

Alternatively, you can download the project source, and execute **gem build telesign.gemspec && gem install telesign-[version].gem**.

Ruby Code Example: Messaging
----------------------------

Here's a basic code example with JSON response.

.. code-block:: ruby

    require 'telesign'

    customer_id = 'customer_id'
    secret_key = 'secret_key'

    phone_number = 'phone_number'
    message = 'You\'re scheduled for a dentist appointment at 2:30PM.'
    message_type = 'ARN'

    messaging_client = Telesign::MessagingClient.new(customer_id, secret_key)
    response = messaging_client.message(phone_number, message, message_type)

.. code-block:: javascript

    {"reference_id"=>"B56A497C9A74016489525132F8840634",
     "status"=>
      {"updated_on"=>"2017-03-03T04:13:14.028347Z",
       "code"=>103,
       "description"=>"Call in progress"}}

For more examples, see the examples folder or visit `TeleSign Developer Portal <https://developer.telesign.com/>`_.

Authentication
--------------

You will need a Customer ID and API Key in order to use TeleSign’s REST API. If you are already a customer and need an
API Key, you can generate one in the `Portal <https://portal.telesign.com>`_.

Testing
-------

To run the Ruby SDK test suite:

.. code-block:: bash

    $ rake test
