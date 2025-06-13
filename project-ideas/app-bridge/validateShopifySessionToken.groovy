import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.interfaces.DecodedJWT
import com.auth0.jwt.exceptions.JWTVerificationException
import java.time.Instant

validToken = false

try {
    // Step 1: Decode JWT to extract claims
    DecodedJWT jwt = JWT.decode(parameters.sessionToken)
    String shopDomain = jwt.getClaim("dest").asString()
    String clientId = jwt.getClaim("aud").asString()
    String userId = jwt.getClaim("sub").asString()
    String issuer = jwt.getIssuer()
    Long exp = jwt.getClaim("exp").asLong()
    Long nbf = jwt.getClaim("nbf").asLong()

    if (!clientId || !shopDomain || !userId) {
        ec.logger.warn("Missing required claims: aud=${clientId}, dest=${shopDomain}, sub=${userId}")
        return
    }

    // Step 2: Lookup ShopifyApp using aud = clientId
    def shopifyApp = ec.entity.find("co.hotwax.shopify.app.ShopifyApp")
                         .condition("clientId", clientId)
                         .useCache(true)
                         .one()
    if (!shopifyApp) {
        ec.logger.warn("No ShopifyApp found for clientId: ${clientId}")
        return
    }
    String clientSecret = shopifyApp.clientSecret

    // Step 3: Validate time-based constraints
    long now = Instant.now().getEpochSecond()
    if (exp && exp <= now) {
        ec.logger.warn("Token has expired (exp=${exp}, now=${now})")
        return
    }
    if (nbf && nbf > now) {
        ec.logger.warn("Token not valid yet (nbf=${nbf}, now=${now})")
        return
    }

    // Step 4: Signature verification
    Algorithm algorithm = Algorithm.HMAC256(clientSecret)
    JWT.require(algorithm).withIssuer("${shopDomain}/admin").build().verify(parameters.sessionToken)

    // Step 5: Build externalAuthId and lookup/create UserLogin
    String externalAuthId = "${shopDomain}#${userId}"
    def userLogin = ec.entity.find("moqui.security.UserLogin")
                         .condition("externalAuthId", externalAuthId)
                         .useCache(true)
                         .one()

    if (!userLogin) {
        // Create new Party + UserLogin
        def newParty = ec.entity.makeValue("moqui.party.Party")
                            .set("partyTypeEnumId", "PtyPerson")
                            .create()

        userLogin = ec.entity.makeValue("moqui.security.UserLogin")
                          .set("userLoginId", externalAuthId)
                          .set("externalAuthId", externalAuthId)
                          .set("isExternal", "Y")
                          .set("partyId", newParty.partyId)
                          .create()

        // Assign to default security group
        ec.entity.makeValue("moqui.security.UserGroupMember")
           .set("userLoginId", externalAuthId)
           .set("groupId", "SHOPIFY_USER")
           .set("fromDate", ec.user.nowTimestamp)
           .create()
    }

    // Step 6: Generate a Moqui login token
    Map loginResult = ec.service.sync().name("create#moqui.security.UserAccountToken")
        .parameters([userLoginId: userLogin.userLoginId])
        .call()

    // Step 7: Output
    context.validToken = true
    context.userLoginId = userLogin.userLoginId
    context.partyId = userLogin.partyId
    context.shopDomain = shopDomain
    context.userId = userId
    context.appId = shopifyApp.appId
    context.moquiToken = loginResult.authToken

} catch (JWTVerificationException e) {
    ec.logger.warn("JWT verification failed: ${e.message}")
    ec.message.addError("Invalid session token.")
}