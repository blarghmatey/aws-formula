{% from "aws/map.jinja" import aws with context %}

{% set alarms = salt['pillar.get']('aws:cloudwatch:alarms', []) %}
{% set aws_key = salt['pillar.get']('aws:key', None) %}
{% set aws_secret_key = salt['pillar.get']('aws:secret_key', None) %}

{% for alarm in alarms %}

{% set name = alarm.name %}
{% set region = alarm.get('region', 'us-east-1') %}
{% set attributes = alarm.get('attributes', {}) %}

create_cloudwatch_alarm_{{ name }}:
  boto_cloudwatch_alarm.present:
    - name: {{ name }}
    - region: {{ region }}
    - key: {{ aws_secret_key }}
    - keyid: {{ aws_key }}
    - attributes: {{ attributes }}

{% endfor %}