# Ansible Argument Specification Pattern

When creating or updating `ansible.builtin.validate_argument_spec` specification for Ansible, follow this pattern:

## Structure

```yaml
---
argument_specs:
  main:
    short_description: <brief description>
    
    options:
      # INPUTS - no prefix in description
      input_param:
        description: "<description>"
        type: <str|int|bool|list|dict>
        required: <true|false>
        # Optional: default, choices, elements, etc.
        
      # OUTPUTS - prefix with [OUTPUT], always required: false
      output_param:
        description: "[OUTPUT] <description>"
        type: <str|int|bool|list|dict>
        required: false
```

## Rules

**INPUTS:**
- Description has NO prefix
- May have `required: true` or `required: false`
- Can have `default`, `choices`, `elements`, etc.
- These are parameters passed TO the Ansible

**OUTPUTS:**
- Description MUST start with `[OUTPUT]` prefix (uppercase, in brackets)
- MUST have `required: false`
- These are variables SET by the Ansible
- Document the type accurately

## Example
```yaml
---
argument_specs:
  main:
    short_description: Generates greeting messages
    
    options:
      name:
        description: "Name to greet"
        type: str
        required: true
        
      greeting_style:
        description: "Style of greeting"
        type: str
        choices: ['formal', 'casual']
        default: casual
        
      greeting_message:
        description: "[OUTPUT] The generated greeting message"
        type: str
        required: false
        
      greeting_timestamp:
        description: "[OUTPUT] When the greeting was generated (ISO 8601 format)"
        type: str
        required: false
```
