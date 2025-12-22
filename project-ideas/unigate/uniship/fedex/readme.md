# FedEx Gateway Integration

This folder contains documents related to integrating FedEx shipping services into the UniShip Microservice.

## Documents

- **fedex-access-token-manager-design.md**  
  Design document for managing FedEx OAuth access tokens securely and efficiently for each retailer tenant.

- **fedex-oauth-and-label-implementation.md**  
  Practical implementation details for obtaining FedEx OAuth tokens and generating shipping labels using the FedEx API.

## Notes

- Access token management uses Moqui framework's cache system.
- OAuth token expiration is handled carefully based on token issue timestamps, not only cache TTL.
- Design aligned for multi-tenant, scalable operations.

