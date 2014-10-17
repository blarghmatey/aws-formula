{% from "aws/map.jinja" import aws with context %}

{% set attributes = salt['pillar.get']('aws:elb:attributes', {}) %}
{% set availability_zones = salt['pillar.get']('aws:elb:availability_zones', None) %}
{% set aws_key = salt['pillar.get']('aws:key', None) %}
{% set aws_region = salt['pillar.get']('aws:region', 'us-east-1') %}
{% set aws_secret_key = salt['pillar.get']('aws:secret_key', None) %}
{% set cnames = salt['pillar.get']('aws:elb:cnames', []) %}
{% set elb_name = salt['pillar.get']('aws:elb:name', 'default_elb') %}
{% set health_check = salt['pillar.get']('aws:elb:health_check', {'target': 'HTTP:80/'}) %}
{% set listeners = salt['pillar.get']('aws:elb:listeners', []) %}
{% set security_groups = salt['pillar.get']('aws:elb:security_groups', []) %}
{% set subnets = salt['pillar.get']('aws:elb:subnets', []) %}

provision_elb:
  boto_elb.present:
    - name: {{ elb_name }}
    - region: {{ aws_region }}
    - keyid: {{ aws_key }}
    - key: {{ aws_secret_key }}
    {% if availability_zones %}
    - availability_zones: {{ availability_zones }}
    {% endif %}
    {% if listeners %}
    - listeners:
        {% for listener in listeners %}
        - {{ listener }}
        {% endfor %}
    {% endif %}
    {% if health_check %}
    - health_check: {{ health_check }}
    {% endif %}
    {% if security_groups %}
    - security_groups:
        {% for group in security_groups %}
        - {{ group }}
        {% endfor %}
    {% endif %}
    {% if subnets %}
    - subnets:
        {% for subnet in subnets %}
        - {{ subnet }}
        {% endfor %}
    {% endif %}
    {% if cnames %}
    - cnames:
        {% for cname in cnames %}
        - {{ cname }}
        {% endfor %}
    {% endif %}
    {% if attributes %}
    - attributes: {{ attributes }}
    {% endif %}